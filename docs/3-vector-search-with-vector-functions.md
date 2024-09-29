# Vector Search with Vector Functions

This SQL script demonstrates how to perform a vector search using vector functions within a SQL database. The goal is to find the top 10 most relevant products from the `walmart_product_details` table that match a given search query based on semantic similarity.

## How It Works

1. **Text to Vector Conversion**:
   - The search text, in this case, 'help me plan a high school graduation party', is declared as an `nvarchar(max)` variable named `@search_text`.
   - A `vector(1536)` variable named `@search_vector` is declared to store the vector representation of the search text.

2. **Creating Embeddings**:
   - The `dbo.create_embeddings` stored procedure is executed with `@search_text` as input and `@search_vector` as output.
   - This procedure converts the search text into a vector embedding, which captures the semantic meaning of the text.

3. **Vector Search Query**:
   - The `SELECT` statement retrieves the top 10 records from the `walmart_product_details` table.
   - The `vector_distance` function computes the 'cosine' distance between the `@search_vector` and the `product_description_vector` column in the table.
   - The results are ordered by the `distance`, with the closest vectors (most semantically similar) appearing first.

## SQL Script

```SQL
-- Declare the search text
declare @search_text nvarchar(max) = 'help me plan a high school graduation party';

-- Declare a variable to hold the search vector
declare @search_vector vector(1536);

-- Generate the search vector using the 'create_embeddings' stored procedure
exec dbo.create_embeddings @search_text, @search_vector output;

-- Perform the search query
SELECT TOP(10) 
  id, product_name, description, 
  -- Calculate the cosine distance between the search vector and product description vectors
  vector_distance('cosine', @search_vector, product_description_vector) AS distance
FROM [dbo].[walmart_product_details]
ORDER BY distance; -- Order by the closest distance
```

As there are duplicate products, rewriting query to remove duplicates

## SQL Script

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
  description, 
  -- Calculate the cosine distance between the search vector and product description vectors
  vector_distance('cosine', @search_vector, product_description_vector) AS distance
FROM (
  SELECT 
    id, 
    product_name, 
    description, 
    product_description_vector,
    ROW_NUMBER() OVER (PARTITION BY product_name, description ORDER BY (SELECT NULL)) AS rn
  FROM [dbo].[walmart_product_details]
) AS unique_products
WHERE rn = 1
ORDER BY distance;
```
