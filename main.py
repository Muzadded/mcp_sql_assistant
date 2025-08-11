import streamlit as st
import asyncio
import os
from dotenv import load_dotenv
from client.client_module import run_optimized_query

# Load environment variables
load_dotenv()

# Page configuration
st.set_page_config(
    page_title="MCP SQL Assistant - Optimized",
    page_icon="⚡",
    layout="wide"
)

st.title("⚡ MCP SQL Assistant - Optimized for Large Databases")
st.markdown("Ask questions about your database and get intelligent, fast answers!")

# Check if GROQ_API_KEY is set
if not os.getenv("GROQ_API_KEY"):
    st.error("⚠️ GROQ_API_KEY not found! Please set it in your .env file.")
    st.code("GROQ_API_KEY=your_groq_api_key_here")
    st.stop()

# Database connection info
with st.sidebar:    
    st.header("🔗 Connection Status")
    st.info("📊 Database: mysql://localhost/bigshop")
    
    # Performance mode selection
    st.header("💡 Sample Questions")
    st.markdown("""
    **Inventory Questions:**
    - How many cargo jeans do I have in inventory?
    - Show all the products
    - What are the attributes for cargo jeans
    """)

# Main query interface
st.header("Ask Your Question")

# Text input for custom queries
query = st.text_input(
    "Or ask your own question:",
    value=st.session_state.get('query', ''),
    placeholder="e.g., How many cargo jeans do I have in stock?",
    key="query_input"
)

if query:
    # Clear the session state query after using it
    if 'query' in st.session_state:
        del st.session_state.query
    
    # Show processing info
    processing_info = st.empty()

    with st.spinner("🤔 Analyzing your question and querying the database..."):
        try:
            # Run the query using selected method
            result = asyncio.run(run_optimized_query(query))

            if result["error"]:
                st.error(f"❌ Error occurred:")
                st.code(result['output'])

            else:
                # Display results
                success_msg = "✅ Query processed successfully!"
                if result.get("method") == "optimized":
                    success_msg += " (⚡ Optimized mode used)"
                elif result.get("tokens_saved"):
                    success_msg += " (💰 Tokens saved with optimization)"

                st.success(success_msg)
                
                # Create tabs for better organization
                tab1, tab2, tab3, tab4 = st.tabs(["🤖 AI Response", "🔍 SQL Queries", "📊 Performance", "📋 Details"])
                
                with tab1:
                    st.markdown("### AI Assistant Response:")
                    st.markdown(result["output"])
                    # st.markdown(result["sql_queries"])
                
                with tab2:
                    st.markdown("### Generated SQL Queries:")
                    if result["sql_queries"]:
                        for i, sql_query in enumerate(result["sql_queries"], 1):
                            col_query, col_copy = st.columns([4, 1])
                            
                            with col_query:
                                st.markdown(f"**Query {i}:**")
                                st.code(sql_query, language="sql")
                            
                            with col_copy:
                                st.markdown("**Actions:**")
                                if st.button(f"📋 Copy", key=f"copy_{i}"):
                                    st.success(f"Query {i} copied!")
                                
                                # Query complexity analysis
                                if st.button(f"📊 Analyze", key=f"analyze_{i}"):
                                    complexity_info = {
                                        "length": len(sql_query),
                                        "has_joins": "JOIN" in sql_query.upper(),
                                        "has_limit": "LIMIT" in sql_query.upper(),
                                        "has_group_by": "GROUP BY" in sql_query.upper()
                                    }
                                    st.json(complexity_info)
                            
                            if i < len(result["sql_queries"]):
                                st.markdown("---")
                    else:
                        st.info("ℹ️ No SQL queries were detected. The AI used schema exploration or provided general information.")
                
                with tab3:
                    st.markdown("### Performance Metrics:")
                    
                    col_perf1, col_perf2 = st.columns(2)
                    
                    with col_perf1:
                        st.metric("Processing Method", result.get("method", "Unknown"))
                        st.metric("SQL Queries Generated", len(result.get("sql_queries", [])))
                        
                        if result.get("tokens_saved"):
                            st.success("💰 Tokens optimized!")
                        
                        if result.get("method") == "optimized":
                            st.success("⚡ Fast processing used!")
                    
                    with col_perf2:
                        response_length = len(result.get("output", ""))
                        st.metric("Response Length", f"{response_length} chars")

                with tab4:
                    col_details1, col_details2 = st.columns([2, 1])
                    with col_details1:
                        st.markdown("### Processing Summary:")
                        st.info(f"✅ Query processed successfully using {result.get('method', 'unknown')} method")
                        st.info(f"🔢 SQL queries found: {len(result['sql_queries'])}")
                        st.info(f"📝 Response length: {len(result['output'])} characters")

                        # Show additional metadata
                        if result.get("method"):
                            st.info(f"⚙️ Processing method: {result['method']}")
                        
                    with col_details2:
                        st.markdown("### Export Options:")
                        
                        # Download SQL queries if available
                        if result["sql_queries"]:
                            sql_content = "-- Generated SQL Queries (Optimized) --\n"
                            sql_content += f"-- Question: {query}\n"
                            sql_content += f"-- Processing method: {result.get('method', 'unknown')}\n"
                            sql_content += f"-- Generated on: {st.session_state.get('timestamp', 'Unknown')}\n\n"
                            
                            for i, sql_query in enumerate(result["sql_queries"], 1):
                                sql_content += f"-- Query {i}\n{sql_query};\n\n"
                            
                            st.download_button(
                                label="📥 Download SQL",
                                data=sql_content,
                                file_name=f"optimized_sql_{query[:20].replace(' ', '_')}.sql",
                                mime="text/sql"
                            )
                        
                        # Download full response
                        response_content = f"MCP SQL Assistant Response (Optimized)\n"
                        response_content += f"=" * 50 + "\n\n"
                        response_content += f"Question: {query}\n"
                        response_content += f"Processing Method: {result.get('method', 'unknown')}\n"
                        response_content += f"Tokens Optimized: {result.get('tokens_saved', False)}\n\n"
                        response_content += f"AI Response:\n{result['output']}\n\n"
                        
                        if result["sql_queries"]:
                            response_content += "Generated SQL Queries:\n"
                            for i, sql_query in enumerate(result["sql_queries"], 1):
                                response_content += f"{i}. {sql_query}\n"
                                
                        st.download_button(
                            label="📄 Download Response",
                            data=response_content,
                            file_name=f"mcp_response_{query[:20].replace(' ', '_')}.txt",
                            mime="text/plain"
                        )
        except Exception as e:
            processing_info.empty()
            st.error(f"❌ Unexpected error: {str(e)}")

            with st.expander("🔧 Error Details"):
                st.code(str(e))
                st.markdown("### Troubleshooting Steps:")
                st.markdown("""
                1. **Check MCP Server**: Ensure server/mcp_server.py is running
                2. **Verify Database**: Ensure MySQL is running and 'bigshop' database exists
                3. **Check Environment**: Verify GROQ_API_KEY is set correctly
                4. **Try Simple Query**: Start with "What tables are available?"
                5. **Check Logs**: Look at the console/terminal for detailed error messages
                6. **Switch Modes**: Try the other processing mode if one fails
                """)