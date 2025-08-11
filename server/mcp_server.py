import sys
import os
import logging
import json
import time
from typing import Dict, Optional

# Add the project root to Python path
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, project_root)

from mcp.server.fastmcp import FastMCP
from tools.sql_tools import OptimizedSQLQueryTool

# Set up logging with more detailed format
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create the MCP server
mcp = FastMCP("optimized_sql")

# Initialize SQL tool with error handling and performance monitoring
sql_tool = None
performance_stats = {
    "queries_executed": 0,
    "total_execution_time": 0,
    "cache_hits": 0,
    "errors": 0,
    "start_time": time.time()
}

try:
    sql_tool = OptimizedSQLQueryTool(db_uri="mysql+pymysql://root:@localhost/bigshop")
    logger.info("✅ Optimized SQL tool initialized successfully")
except Exception as e:
    logger.error(f"❌ Failed to initialize SQL tool: {e}")
    sys.exit(1)

def log_performance(func_name: str, execution_time: float, success: bool = True):
    """Log performance metrics"""
    performance_stats["queries_executed"] += 1
    performance_stats["total_execution_time"] += execution_time
    
    if not success:
        performance_stats["errors"] += 1
    
    logger.info(f"📊 {func_name}: {execution_time:.3f}s ({'✅' if success else '❌'})")

@mcp.tool(name="run_query")
def run_query(query: str) -> str:
    """Execute a SQL query with performance monitoring and optimization"""
    start_time = time.time()
    try:
        logger.info(f"🔍 Executing query: {query[:100]}{'...' if len(query) > 100 else ''}")
        
        # Analyze query complexity before execution
        complexity = sql_tool.analyze_query_complexity(query)
        if complexity['complexity_level'] == 'High':
            logger.warning(f"⚠️ High complexity query detected (score: {complexity['complexity_score']})")
            logger.info(f"💡 Suggestions: {', '.join(complexity['optimization_suggestions'])}")
        
        result = sql_tool.run_query(query)
        execution_time = time.time() - start_time
        
        log_performance("run_query", execution_time, True)
        logger.info(f"✅ Query executed successfully in {execution_time:.3f}s")
        
        # Return result with performance info for debugging
        if len(str(result)) > 1000:
            logger.info(f"📊 Large result set returned ({len(str(result))} characters)")
        
         # Ensure JSON output
        output = {
            "optimized_query": query,
            "result": result
        }
        return json.dumps(output, default=str)  # default=str makes SQLAlchemy rows serializable
        
    except Exception as e:
        execution_time = time.time() - start_time
        log_performance("run_query", execution_time, False)
        
        error_msg = f"❌ Error executing query: {str(e)}"
        logger.error(error_msg)
        # Return error as JSON too
        return json.dumps({
            "optimized_query": query,
            "execution_time_seconds": round(execution_time, 3),
            "error": error_msg
        })

@mcp.tool(name="get_table_info")
def get_schema_info(table_name: str = None) -> str:
    """Get information about database tables with caching"""
    start_time = time.time()
    try:
        if table_name:
            logger.info(f"📋 Getting table info for: {table_name}")
            result = sql_tool.get_table_info(table_name)
            logger.info(f"✅ Retrieved info for table: {table_name}")
        else:
            logger.info(f"📋 Getting all tables information")
            result = sql_tool.get_all_tables()
            logger.info(f"✅ Retrieved all tables information")
        
        execution_time = time.time() - start_time
        log_performance("get_table_info", execution_time, True)
        
        return str(result)
        
    except Exception as e:
        execution_time = time.time() - start_time
        log_performance("get_table_info", execution_time, False)
        
        error_msg = f"❌ Error getting table info: {str(e)}"
        logger.error(error_msg)
        return error_msg

@mcp.tool(name="get_focused_schema")
def get_focused_schema(relevant_tables: str = None) -> str:
    """Get schema information for specific tables only (performance optimized)"""
    start_time = time.time()
    try:
        logger.info(f"🎯 Getting focused schema for: {relevant_tables or 'auto-detected tables'}")
        
        # Parse relevant tables if provided as comma-separated string
        tables_list = None
        if relevant_tables:
            tables_list = [t.strip() for t in relevant_tables.split(',')]
        
        result = sql_tool.get_focused_schema_info(tables_list)
        execution_time = time.time() - start_time
        
        log_performance("get_focused_schema", execution_time, True)
        logger.info(f"✅ Focused schema retrieved in {execution_time:.3f}s")
        
        return str(result)
        
    except Exception as e:
        execution_time = time.time() - start_time
        log_performance("get_focused_schema", execution_time, False)
        
        error_msg = f"❌ Error getting focused schema: {str(e)}"
        logger.error(error_msg)
        return error_msg

@mcp.tool(name="get_sample_data")
def get_sample_data(table_name: str, limit: int = 3) -> str:
    """Get sample data from a table for better context"""
    start_time = time.time()
    try:
        logger.info(f"🔍 Getting sample data from: {table_name} (limit: {limit})")
        result = sql_tool.get_table_sample_data(table_name, limit)
        execution_time = time.time() - start_time
        
        log_performance("get_sample_data", execution_time, True)
        
        return str(result)
        
    except Exception as e:
        execution_time = time.time() - start_time
        log_performance("get_sample_data", execution_time, False)
        
        error_msg = f"❌ Error getting sample data: {str(e)}"
        logger.error(error_msg)
        return error_msg

@mcp.tool(name="get_last_query")
def get_last_query() -> str:
    """Get the last executed SQL query and its result with performance metrics"""
    start_time = time.time()
    try:
        logger.info(f"📊 Getting last query information")
        query_info = sql_tool.get_last_query()
        
        # Format the response with performance data
        response = f"""Last Query Information:

Query: {query_info.get('query', 'No query available')}
Optimized Query: {query_info.get('optimized_query', 'Same as original')}
Execution Time: {query_info.get('execution_time', 'Unknown')}s

Performance Analysis:
{query_info.get('performance_analysis', {})}

Result Preview:
{str(query_info.get('result', 'No result'))[:500]}{'...' if len(str(query_info.get('result', ''))) > 500 else ''}
"""
        
        execution_time = time.time() - start_time
        log_performance("get_last_query", execution_time, True)
        
        return response
        
    except Exception as e:
        execution_time = time.time() - start_time
        log_performance("get_last_query", execution_time, False)
        
        error_msg = f"❌ Error getting last query: {str(e)}"
        logger.error(error_msg)
        return error_msg

@mcp.tool(name="get_performance_stats")
def get_performance_stats() -> str:
    """Get server performance statistics"""
    try:
        uptime = time.time() - performance_stats["start_time"]
        
        # Get SQL tool specific stats
        sql_stats = sql_tool.get_query_performance_stats()
        cache_stats = sql_tool.get_cache_stats()
        
        stats_report = f"""MCP Server Performance Statistics:

Server Uptime: {uptime:.2f} seconds
Total Queries: {performance_stats['queries_executed']}
Total Execution Time: {performance_stats['total_execution_time']:.3f}s
Average Query Time: {(performance_stats['total_execution_time'] / max(1, performance_stats['queries_executed'])):.3f}s
Errors: {performance_stats['errors']}
Success Rate: {((performance_stats['queries_executed'] - performance_stats['errors']) / max(1, performance_stats['queries_executed']) * 100):.1f}%

SQL Tool Statistics:
{sql_stats}

Cache Statistics:
{cache_stats}
"""
        
        logger.info("📊 Performance statistics requested")
        return stats_report
        
    except Exception as e:
        error_msg = f"❌ Error getting performance stats: {str(e)}"
        logger.error(error_msg)
        return error_msg

@mcp.tool(name="clear_cache")
def clear_cache() -> str:
    """Clear all caches for fresh data"""
    try:
        sql_tool.clear_cache()
        logger.info("🧹 All caches cleared successfully")
        return "✅ All caches have been cleared successfully"
        
    except Exception as e:
        error_msg = f"❌ Error clearing cache: {str(e)}"
        logger.error(error_msg)
        return error_msg

@mcp.tool(name="optimize_query")
def optimize_query(query: str) -> str:
    """Analyze and suggest optimizations for a query without executing it"""
    try:
        logger.info(f"🔧 Analyzing query for optimization: {query[:50]}...")
        
        analysis = sql_tool.analyze_query_complexity(query)
        
        optimization_report = f"""Query Optimization Analysis:

Original Query: {query}

Complexity Analysis:
- Complexity Score: {analysis['complexity_score']}
- Complexity Level: {analysis['complexity_level']}

Optimization Suggestions:
{chr(10).join(f"• {suggestion}" for suggestion in analysis['optimization_suggestions'])}

Recommended Actions:
{'• Consider adding indexes on joined columns' if 'JOIN' in query.upper() else ''}
{'• Use LIMIT clause to restrict result size' if 'LIMIT' not in query.upper() and 'SELECT' in query.upper() else ''}
{'• Consider using specific column names instead of SELECT *' if 'SELECT *' in query.upper() else ''}
"""
        
        return optimization_report
        
    except Exception as e:
        error_msg = f"❌ Error analyzing query: {str(e)}"
        logger.error(error_msg)
        return error_msg

if __name__ == "__main__":
    logger.info("🚀 Starting Enhanced MCP SQL Server with performance monitoring...")
    logger.info(f"📊 Performance tracking enabled")
    logger.info(f"💾 Caching system active")
    logger.info(f"⚡ Query optimization enabled")
    
    try:
        mcp.run(transport="stdio")
    except KeyboardInterrupt:
        logger.info("🛑 Server shutdown requested")
        
        # Log final performance stats
        uptime = time.time() - performance_stats["start_time"]
        logger.info(f"📊 Final Stats - Uptime: {uptime:.1f}s, Queries: {performance_stats['queries_executed']}, Errors: {performance_stats['errors']}")
        
    except Exception as e:
        logger.error(f"❌ Failed to start MCP server: {e}")
        sys.exit(1)


