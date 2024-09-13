# Filtered Semantic Search with SQL

This section explains the implementation of a Filtered Search query in SQL. The Hybrid Search combines traditional SQL queries with vector-based search capabilities to provide enhanced search results.

## SQL Query for Hybrid Search

The following SQL script demonstrates how to perform a hybrid search in a SQL database. It uses vector embeddings to find the most relevant products based on a textual description and combines with Available=True and Sale price of <=50.

## SQL Script

```SQL
-- Declare the search text
declare @search_text nvarchar(max) = 'help me plan a high school graduation party'

-- Declare a variable to hold the search vector
declare @search_vector vector(1536)

-- Generate the search vector using the 'create_embeddings' stored procedure
exec dbo.create_embeddings @search_text, @search_vector output;

SELECT TOP(10) 
  id, product_name, description, 
  -- Calculate the cosine distance between the search vector and product description vectors
  vector_distance('cosine', @search_vector, product_description_vector) AS distance
FROM [dbo].[walmart_product_details]
WHERE sale_price <= 50 -- Filter by sale price
AND available = 'TRUE' -- Filter by availability
ORDER BY distance; -- Order by the closest distance
```