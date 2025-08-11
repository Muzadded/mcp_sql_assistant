import os
import logging
import json
import re
from typing import Dict, List
from mcp_use import MCPClient, MCPAgent
from langchain_groq import ChatGroq

# Logging setup
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DatabaseSchemaCache:
    """Cache for schema information and table relevance."""

    _table_keywords = {
        'products': ['product', 'item', 'goods', 'inventory', 'stock', 'jeans', 'cargo', 'clothing'],
        'orders': ['order', 'purchase', 'buy', 'sale', 'transaction'],
        'users': ['user', 'customer', 'client', 'account'],
        'categories': ['category', 'type', 'kind', 'classification'],
        'product_inventory': ['inventory', 'stock', 'quantity', 'available'],
        'product_attributes': ['size', 'color', 'variant', 'attribute'],
        'order_product': ['order', 'purchase', 'buy'],
    }

    _schemas = {
        'admins': """
admins table:
- id (Primary Key): Unique identifier for each user, auto-incremented and unsigned bigint.
- name: User's name.
- email (Unique Key): User's email address.
- password: User's password (hashed).
- remember_token: Token for "remember me" functionality, nullable.
- created_at: Timestamp when the user was created, nullable.
- updated_at: Timestamp when the user was last updated, nullable.
""",

        'users': """
users table:
- id (Primary Key): Unique identifier for each user, auto-incremented and unsigned bigint.
- name: User's name.
- email (Unique Key): User's email address.
- email_verified_at: Timestamp when the user's email was verified, nullable.
- password: User's password (hashed).
- remember_token: Token for "remember me" functionality, nullable.
- created_at: Timestamp when the user was created, nullable.
- updated_at: Timestamp when the user was last updated, nullable.
""",
        'products': """
products table:
- product_id (Primary Key): Unique product identifier
- product_title: Product name/title
- category_id: Links to categories table
- product_price: Product price
- product_sku: Stock keeping unit
- is_featured: Boolean for featured products
- active_status: Boolean for active products
Join: products.product_id = product_inventory.product_id (stock info)
Join: products.product_id = product_attributes.product_id (variants)
""",
            'product_inventory': """
product_inventory table:
- product_stock_id (Primary Key)
- product_id: Links to products.product_id
- stock_amount: Available quantity
Join: product_inventory.product_id = products.product_id
""",
            'categories': """
categories table:
- category_row_id (Primary Key)
- category_name: Category name
- parent_id: For nested categories
Join: categories.category_row_id = products.category_id
""",
            'product_attributes': """
product_attributes table:
- product_attr_id (Primary Key)
- product_id: Links to products.product_id
- attribute_title: Attribute name (size, color, etc.)
- attribute_quantity: Stock for this variant
Join: product_attributes.product_id = products.product_id
"""
    }

    def __init__(self):
        self._schema_cache: Dict[str, str] = {}

    def get_relevant_tables(self, query: str) -> List[str]:
        q = query.lower()
        relevant = [t for t, kws in self._table_keywords.items() if any(k in q for k in kws)]
        return relevant or ['products', 'users', 'orders']

    def get_focused_schema(self, tables: List[str]) -> str:
        key = "|".join(sorted(tables))
        if key not in self._schema_cache:
            self._schema_cache[key] = "\n".join(
                self._schemas[t] for t in tables if t in self._schemas
            )
        return self._schema_cache[key]
    

def extract_output_from_result(result) -> str:
    """Normalize LLM or agent output into a string."""
    if result is None:
        return ""
    if isinstance(result, str):
        return result
    if hasattr(result, 'output'):
        return str(result.output)
    if hasattr(result, 'content'):
        return str(result.content)
    if hasattr(result, 'text'):
        return str(result.text)
    if isinstance(result, dict):
        for key in ['output', 'content', 'text', 'response', 'result']:
            if key in result:
                return str(result[key])
    return str(result)

# Compile regex patterns once for performance
SQL_PATTERNS = [
    re.compile(r'```sql\s*\n(.*?)\n```', re.IGNORECASE | re.DOTALL),
    re.compile(r'"query":\s*"([^"]*?(SELECT|INSERT|UPDATE|DELETE|SHOW|DESCRIBE)[^"]*)"', re.IGNORECASE | re.DOTALL),
    re.compile(r'\b(SELECT|INSERT|UPDATE|DELETE|SHOW|DESCRIBE)[^;]*(?:;|$)', re.IGNORECASE | re.MULTILINE),
]

def extract_sql_queries_from_output(text: str) -> List[str]:
    queries = []
    seen = set()
    for pattern in SQL_PATTERNS:
        for match in pattern.findall(text):
            query = clean_sql_query(match[0] if isinstance(match, tuple) else match)
            if query and query not in seen:
                seen.add(query)
                queries.append(query)
    return queries

def clean_sql_query(q: str) -> str:
    return re.sub(r'\s+', ' ', q.strip()).rstrip(';').replace('\\"', '"').replace("\\'", "'")

def build_optimized_prompt(user_query: str, schema_cache: DatabaseSchemaCache) -> str:
    schema = schema_cache.get_focused_schema(schema_cache.get_relevant_tables(user_query))
    return f"""You are a SQL assistant for bigshop database.

RELEVANT SCHEMA:
{schema}

USER QUERY: "{user_query}"

TASK: Generate precise SQL query considering:
1. Use JOINs for related tables
2. Add LIMIT for large result sets
3. Focus only on the specific question

# Provide only the SQL query and the query result, no explanation.
 """

async def run_optimized_query(user_query: str):
    groq_api_key = os.getenv("GROQ_API_KEY")
    if not groq_api_key:
        return {"output": "Missing GROQ_API_KEY", "sql_queries": [], "error": True}

    config = {"mcpServers": {"local_sql": {"command": "python", "args": ["server/mcp_server.py"], "transport": "stdio"}}}
    schema_cache = DatabaseSchemaCache()

    try:
        client = MCPClient.from_dict(config)
        llm = ChatGroq(api_key=groq_api_key, model="llama-3.1-8b-instant", temperature=0, max_retries=2)
        agent = MCPAgent(llm=llm, client=client, max_steps=8)

        prompt = build_optimized_prompt(user_query, schema_cache)
        logger.info("Step 1: Generate SQL query")
        raw_result = await agent.run(prompt)


        try:
            result_dict = json.loads(raw_result) if isinstance(raw_result, str) else raw_result
        except json.JSONDecodeError:
            logger.error(f"Invalid JSON from server: {raw_result}")
            return {"output": raw_result, "sql_queries": [], "error": True}

        return {
            "output": result_dict.get("result"),
            "sql_queries": result_dict.get("optimized_query"),
            "error": "error" in result_dict
        }
        # output = extract_output_from_result(result)
        # # sql_queries = extract_sql_queries_from_output(result)
        # sql_queries = result['optimized_query']

        # return {"output": output, "sql_queries": sql_queries, "error": False, "method": "optimized", "tokens_saved": True}
    except Exception as e:
        logger.error(f"Optimized query failed: {e}")
        return {"output": f"Error: {e}", "sql_queries": [], "error": True}
    finally:
        if 'client' in locals():
            await client.close_all_sessions()