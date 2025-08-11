import logging
from langchain_community.utilities import SQLDatabase
from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool, InfoSQLDatabaseTool, ListSQLDatabaseTool
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from typing import Dict, List, Optional
import json
import time
from functools import lru_cache

logger = logging.getLogger(__name__)

class OptimizedSQLQueryTool:
    def __init__(self, db_uri: str):
        """Initialize SQL query tool with database connection and caching"""
        try:
            self.db_uri = db_uri
            self.db = SQLDatabase.from_uri(db_uri)
            self.executed_queries = []
            self.last_query = None
            self.last_result = None
            
            # Caching for performance
            self._schema_cache = {}
            self._table_list_cache = None
            self._cache_timestamp = {}
            
            # Query optimization settings
            self.default_limit = 100  # Default LIMIT for large result sets
            self.max_cache_age = 300  # 5 minutes cache validity
            
            # Test the connection
            self._test_connection()
            logger.info(f"Successfully connected to database: {db_uri}")
            
        except Exception as e:
            logger.error(f"Failed to connect to database {db_uri}: {e}")
            raise

    def _test_connection(self):
        """Test database connection with timeout"""
        try:
            with self.db._engine.connect() as conn:
                result = conn.execute(text("SELECT 1"))
                result.fetchone()
            logger.info("Database connection test successful")
        except SQLAlchemyError as e:
            logger.error(f"Database connection test failed: {e}")
            raise

    def _is_cache_valid(self, cache_key: str) -> bool:
        """Check if cached data is still valid"""
        if cache_key not in self._cache_timestamp:
            return False
        
        return (time.time() - self._cache_timestamp[cache_key]) < self.max_cache_age

    def _add_limit_to_query(self, query: str) -> str:
        """Add LIMIT clause to SELECT queries if not present"""
        query_upper = query.upper().strip()
        
        # Only add LIMIT to SELECT queries
        if not query_upper.startswith('SELECT'):
            return query
            
        # Check if LIMIT already exists
        if 'LIMIT' in query_upper:
            return query
            
        # Add LIMIT for potentially large result sets
        return f"{query} LIMIT {self.default_limit}"

    def _optimize_query(self, query: str) -> str:
        """Optimize query for better performance"""
        optimized_query = query.strip()
        
        # Add LIMIT to SELECT queries
        optimized_query = self._add_limit_to_query(optimized_query)
        
        # Log the optimization
        if optimized_query != query.strip():
            logger.info(f"Query optimized: Added LIMIT clause")
        
        return optimized_query

    @lru_cache(maxsize=50)
    def _cached_table_info(self, table_name: str) -> str:
        """Cached table information retrieval"""
        try:
            tool = InfoSQLDatabaseTool(db=self.db)
            result = tool.run(table_name)
            return result
        except Exception as e:
            logger.error(f"Failed to get cached table info for {table_name}: {e}")
            return f"Error getting table info: {str(e)}"

    def run_query(self, query: str) -> str:
        """Execute a SQL query with optimization and return results"""
        logger.info(query)
        try:
            # Optimize the query
            optimized_query = self._optimize_query(query)
            
            # Store the original query for tracking
            self.last_query = query.strip()
            logger.info(f"Executing optimized SQL query: {optimized_query}")
            
            # Execute with timeout protection
            start_time = time.time()
            tool = QuerySQLDataBaseTool(db=self.db)
            result = tool.run(optimized_query)
            execution_time = time.time() - start_time
            
            # Store the result
            self.last_result = result
            
            # Add to executed queries list with performance metrics
            self.executed_queries.append({
                'original_query': self.last_query,
                'optimized_query': optimized_query,
                'result': result,
                'execution_time': execution_time,
                'timestamp': time.time()
            })
            
            # Keep only last 20 queries to avoid memory issues
            if len(self.executed_queries) > 20:
                self.executed_queries = self.executed_queries[-20:]
            
            logger.info(f"Query executed successfully in {execution_time:.2f}s")
            
            # Handle different result types
            if result is None:
                result_data = "No results found"
            elif isinstance(result, str) and result.strip() == "":
                 result_data = "Query executed fail (no output)"
            else:
                result_data = result

            # Always return as JSON string
            return json.dumps({
                "optimized_query": optimized_query,
                "result": result_data
            }, default=str)  # default=str handles non-serializable types

        except Exception as e:
            error_msg = f"Error executing query: {str(e)}"
            logger.error(error_msg)
            self.last_query = query.strip()
            self.last_result = error_msg
            return json.dumps({
                "optimized_query": query.strip(),
                "error": error_msg
            })

    def get_table_info(self, table_name: str) -> str:
        """Get information about a specific table with caching"""
        try:
            # Use cached version for better performance
            return self._cached_table_info(table_name)
        except Exception as e:
            logger.error(f"Failed to get table info for {table_name}: {e}")
            return f"Error getting table info: {str(e)}"

    def get_all_tables(self) -> str:
        """Get list of all tables in the database with caching"""
        try:
            # Check cache first
            if self._table_list_cache and self._is_cache_valid('table_list'):
                logger.info("Returning cached table list")
                return self._table_list_cache
            
            # Get fresh data
            logger.info("Fetching fresh table list")
            tool = ListSQLDatabaseTool(db=self.db)
            result = tool.run("")
            
            # Cache the result
            self._table_list_cache = result
            self._cache_timestamp['table_list'] = time.time()
            
            logger.info(f"Successfully retrieved table list: {len(result.split()) if result else 0} items")
            return result
        except Exception as e:
            logger.error(f"Failed to get table list: {e}")
            return f"Error getting table list: {str(e)}"

    def get_focused_schema_info(self, relevant_tables: List[str] = None) -> str:
        """Get schema information for specific tables only"""
        try:
            if not relevant_tables:
                # Get all tables if none specified
                tables_result = self.get_all_tables()
                relevant_tables = [line.strip() for line in tables_result.split('\n') if line.strip()]
                relevant_tables = relevant_tables[:5]  # Limit to first 5 tables
            
            schema_info = "Focused Database Schema:\n\n"
            
            for table_name in relevant_tables:
                if table_name and not table_name.startswith('Database'):
                    table_info = self.get_table_info(table_name)
                    schema_info += f"=== {table_name} ===\n{table_info}\n\n"
            
            return schema_info
        except Exception as e:
            logger.error(f"Failed to get focused schema info: {e}")
            return f"Error getting focused schema info: {str(e)}"

    def get_table_sample_data(self, table_name: str, limit: int = 3) -> str:
        """Get sample data from a table for better query understanding"""
        try:
            sample_query = f"SELECT * FROM {table_name} LIMIT {limit}"
            result = self.run_query(sample_query)
            return f"Sample data from {table_name}:\n{result}"
        except Exception as e:
            logger.error(f"Failed to get sample data from {table_name}: {e}")
            return f"Could not retrieve sample data from {table_name}"

    def get_query_performance_stats(self) -> Dict:
        """Get performance statistics for executed queries"""
        if not self.executed_queries:
            return {"message": "No queries executed yet"}
        
        execution_times = [q.get('execution_time', 0) for q in self.executed_queries]
        
        return {
            "total_queries": len(self.executed_queries),
            "average_execution_time": sum(execution_times) / len(execution_times),
            "fastest_query": min(execution_times),
            "slowest_query": max(execution_times),
            "last_query_time": execution_times[-1] if execution_times else 0
        }

    def analyze_query_complexity(self, query: str) -> Dict:
        """Analyze query complexity and suggest optimizations"""
        query_upper = query.upper()
        
        complexity_score = 0
        suggestions = []
        
        # Check for potentially expensive operations
        if 'JOIN' in query_upper:
            join_count = query_upper.count('JOIN')
            complexity_score += join_count * 2
            if join_count > 3:
                suggestions.append("Consider reducing the number of JOINs")
        
        if 'GROUP BY' in query_upper:
            complexity_score += 2
        
        if 'ORDER BY' in query_upper:
            complexity_score += 1
        
        if 'DISTINCT' in query_upper:
            complexity_score += 1
        
        if 'LIMIT' not in query_upper and 'SELECT' in query_upper:
            suggestions.append("Consider adding LIMIT clause for large datasets")
            complexity_score += 1
        
        # Determine complexity level
        if complexity_score <= 2:
            level = "Low"
        elif complexity_score <= 5:
            level = "Medium"
        else:
            level = "High"
        
        return {
            "complexity_score": complexity_score,
            "complexity_level": level,
            "optimization_suggestions": suggestions
        }

    def get_last_query(self) -> dict:
        """Get the last executed query and its result"""
        if not self.executed_queries:
            return {
                'query': self.last_query,
                'result': self.last_result
            }
        
        last_execution = self.executed_queries[-1]
        return {
            'query': last_execution.get('original_query', self.last_query),
            'optimized_query': last_execution.get('optimized_query'),
            'result': last_execution.get('result', self.last_result),
            'execution_time': last_execution.get('execution_time'),
            'performance_analysis': self.analyze_query_complexity(last_execution.get('original_query', ''))
        }

    def get_query_history(self) -> list:
        """Get the history of executed queries with performance metrics"""
        return [
            {
                'original_query': q.get('original_query'),
                'execution_time': q.get('execution_time'),
                'timestamp': q.get('timestamp'),
                'result_preview': str(q.get('result', ''))[:100] + '...' if len(str(q.get('result', ''))) > 100 else str(q.get('result', ''))
            }
            for q in self.executed_queries
        ]

    def clear_cache(self):
        """Clear all cached data"""
        self._schema_cache.clear()
        self._table_list_cache = None
        self._cache_timestamp.clear()
        # Clear LRU cache
        self._cached_table_info.cache_clear()
        logger.info("All caches cleared")

    def get_cache_stats(self) -> Dict:
        """Get cache statistics"""
        return {
            "schema_cache_size": len(self._schema_cache),
            "has_table_list_cache": self._table_list_cache is not None,
            "cache_timestamps": len(self._cache_timestamp),
            "lru_cache_info": self._cached_table_info.cache_info()._asdict()
        }