declare @search_text nvarchar(max) = 'help me plan a high school graduation party'
declare @search_vector vector(1536)

exec dbo.create_embeddings @search_text, @search_vector output;

SELECT TOP(10) 
  id, product_name, description, 
  vector_distance('cosine', @search_vector, product_description_vector) AS distance
FROM [dbo].[walmart_product_details]
WHERE sale_price <= 50
AND available = 'TRUE'
ORDER BY distance