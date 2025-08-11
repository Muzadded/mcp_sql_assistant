# MCP SQL Assistant
 
Ask your database questions in plain English. Get back optimized SQL and results in a simple web app.
 
- Natural language to SQL using a Groq LLM  
- Connects to MySQL out of the box  
- Comes with an MCP server that exposes safe SQL tools  
- Streamlit UI for a friendly, copy-paste experience
 
---
 
## What this does
 
You type: “How many cargo jeans are in stock?”  
The app figures out which tables matter, asks the LLM to generate SQL, runs the query safely, and shows you both the answer and the SQL it used.
 
---
 
## Who this is for
 
- Users who want to explore a MySQL database without writing SQL  
- Teams that want a quick UI for ad-hoc questions  
- Developers who want a clean MCP example they can extend
 
---
 
## Quick start
 
```bash
# 1) Clone and enter
git clone https://github.com/Muzadded/mcp_sql_assistant.git
cd mcp_sql_assistant
 
# 2) Create a virtual environment
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate
 
# 3) Install dependencies
pip install -r requirements.txt
 
# 4) Configure your keys and DB
cp .env.example .env
# open .env and set:
# GROQ_API_KEY=your_key
# DB_URL=mysql+pymysql://user:password@localhost/bigshop
 
# 5) Run the web app
streamlit run main.py
```
# File by file:

# main.py (Streamlit web app):
- The browser UI.
- Loads your .env, checks GROQ_API_KEY, and displays a text box for your question.
- Calls the client to get:
- AI answer in plain text
- One or more generated SQL queries
- Light performance info
- Lets you copy or download the SQL and the response.

# client/client_module.py (AI + MCP client):
- Figures out which tables are relevant using lightweight keyword matching.
- Builds a focused schema prompt for the LLM so it generates tighter SQL.
- Uses Groq llama-3.1-8b-instant to produce the SQL.
- Spins up an MCP client which talks to the local MCP server over stdio:
command: python
args: ["server/mcp_server.py"]
- Normalizes the server response into:
- output (human answer)
- sql_queries (the SQL it used)

If you see ModuleNotFoundError: client.client_module, make sure client_module.py is inside a client/ folder and the import in main.py matches:
```bash
from client.client_module import run_optimized_query
```
server/mcp_server.py (MCP server)
Starts an MCP server named optimized_sql.

Uses OptimizedSQLQueryTool to connect to your DB and handle requests.

# Exposes tools the UI can call:
- run_query(query)
- get_table_info(table_name)
- get_focused_schema(relevant_tables)
- get_sample_data(table_name, limit)
- get_last_query()
- get_performance_stats()
- clear_cache()
- optimize_query(query)
- Logs performance stats and helps you spot heavy queries.
- Connection string is set here when the tool is created. The default is:
```bash
OptimizedSQLQueryTool(db_uri="mysql+pymysql://root:@localhost/bigshop")
```
- Update it to match your DB or change it to read from os.getenv("DB_URL").

# tools/sql_tools.py (DB engine + helpers):
- Connects to the database with SQLAlchemy and LangChain SQL tools.
- Adds a LIMIT automatically to large SELECT queries.
- Caches schema and table lists for speed.
- Tracks query history and returns performance stats.
- Provides a simple complexity analysis with suggestions.

# .env.example:
- Template for environment variables. Copy to .env and fill in:
- GROQ_API_KEY
- DB_URL

# requirements.txt:
- Python packages used across the app:
- mcp, mcp-use, langchain-mcp-adapters
- langchain-groq, langchain-community
- streamlit
- pymysql
