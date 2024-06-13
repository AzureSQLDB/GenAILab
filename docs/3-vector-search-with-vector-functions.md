
## Vector Search with Vector Functions



```SQL
declare @search_text nvarchar(max) = 'help me plan a high school graduation party'
declare @search_vector varbinary(8000)

exec dbo.create_embeddings @search_text, @search_vector output;

SELECT TOP(10) 
  id, product_name, description, 
  vector_distance('cosine', @search_vector, product_description_vector) AS distance
FROM [dbo].[walmart_product_details]
ORDER BY distance