# Filtered Semantic Search with SQL

This section explains the implementation of a Filtered Search query in SQL. The Hybrid Search combines traditional SQL queries with vector-based search capabilities to provide enhanced search results.

## SQL Query for Hybrid Search

The following SQL script demonstrates how to perform a hybrid search in a SQL database. It uses vector embeddings to find the most relevant products based on a textual description and combines with `Available=True` and Sale price of <=50 and other filters.

```SQL
declare @search_text nvarchar(max) = 'help me plan a high school graduation party';

-- Declare a variable to hold the search vector
declare @search_vector vector(1536);

-- Generate the search vector using the 'create_embeddings' stored procedure
exec dbo.create_embeddings @search_text, @search_vector output;

-- Perform the search query
SELECT TOP(10) 
    id, 
    product_name, 
    [description], 
    sale_price,
    category,
    -- Calculate the cosine distance between the search vector and product description vectors
    VECTOR_DISTANCE('cosine', @search_vector, embedding) AS distance
FROM (
    SELECT 
        id, 
        product_name, 
        [description], 
        embedding,
        sale_price,
        category,
        ROW_NUMBER() OVER (PARTITION BY product_name, description ORDER BY (SELECT NULL)) AS rn
    FROM 
        [dbo].[walmart_product_details]
    WHERE
        (category LIKE '%party%' OR category LIKE '%school%')
    AND
        available = 'TRUE'
    AND
       sale_price <= 50 -- Filter by sale price
) AS unique_products
WHERE rn = 1
ORDER BY distance;
```