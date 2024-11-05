# Azure OpenAI Embeddings

An embedding is a special format of data representation that machine learning models and algorithms can easily use. The embedding is an information dense representation of the semantic meaning of a piece of text. Each embedding is a vector of floating-point numbers, such that the distance between two embeddings in the vector space is correlated with semantic similarity between two inputs in the original format. For example, if two texts are similar, then their vector representations should also be similar.

## Embeddings 101

Explore embeddings by vectorizing (creating embeddings) for some common words and calculating the cosine distance between them.

```SQL
declare @apple vector(1536), @banana vector(1536), @dog vector(1536), @cat vector(1536);

exec dbo.create_embeddings 'apple', @apple output;
exec dbo.create_embeddings 'banana', @banana output;
exec dbo.create_embeddings 'dog', @dog output;
exec dbo.create_embeddings 'cat', @cat output;

select 
    *
from
    (values 
        ('apple', 'banana', vector_distance('cosine', @apple, @banana)),
        ('apple', 'dog', vector_distance('cosine', @apple, @dog)),
        ('dog', 'cat', vector_distance('cosine', @dog, @cat)),
        ('apple', 'cat', vector_distance('cosine', @apple, @cat))
    ) T (v1, v2, distance)
```

## Import Walmart Product Sample dataset

A sample dataset of Walmart products is available to be downloaded for free from Kaggle:

https://www.kaggle.com/datasets/mauridb/product-data-from-walmart-usa-with-embeddings

Use the scripts from 01 to 0in the `walmart-product-with-embeddings-dataset-usa.csv` file. 

## Generate embeddings using OpenAI

1. Safely store the credentials to access the Azure OpenAI API by using Database Scoped Credentials. Copy the following SQL and paste it into the SQL query editor. Make sure to replace the `<OPENAI_ACCOUNT>` and `<OPENAI_KEY>` with the OpenAI endpoint and key.

    ```SQL
    create database scoped credential [https://<OPENAI_ACCOUNT>.openai.azure.com/openai] 
    with identity = 'HTTPEndpointHeaders', secret = N'{"api-key":"<OPENAI_KEY>"}';
    ```

1. Copy the following SQL and paste it into the SQL query editor. You can see from the T-SQL that we are going to create an embedding for a product name from data in the Azure SQL Database. The query `SELECT [description] FROM [dbo].[walmart_product_details] WHERE id = 2` returns "**5.0 oz., 100% pre-shrunk cotton Athletic Heather .....**" and will be sent to the OpenAI REST endpoint. Replace `<OPENAI_ACCOUNT>` and `<DEPLOYMENT>` with your OpenAI account and deployment.
 
    ```SQL
    declare @url nvarchar(1000) = N'https://<OPENAI_ACCOUNT>.openai.azure.com/openai/deployments/<DEPLOYMENT>/embeddings?api-version=2024-02-01';
    declare @message nvarchar(max);
    SET @message = (SELECT [description] FROM [dbo].[walmart_product_details] WHERE id = 2);
    declare @payload nvarchar(max) = N'{"input": "' + @message + '"}';

    declare @ret int, @response nvarchar(max);

    exec @ret = sp_invoke_external_rest_endpoint 
        @url = @url,
        @method = 'POST',
        @credential = [https://<OPENAI_ACCOUNT>.openai.azure.com/openai],
        @payload = @payload,
        @timeout = 230,
        @response = @response output;

    -- The REST API response
    select @ret as ReturnCode, @response as Response;    

    -- Extract the JSON Array
    declare @json_embedding nvarchar(max) = json_query(@response, '$.result.data[0].embedding');  
    select @json_embedding, cast(@json_embedding AS vector(1536)) as embedding;
    ```

1. Execute the SQL statement with the run button.

1. View the return message. It contains the vector representation of our product name input that can now be easily consumed by machine learning models and other algorithms. It can even be stored locally in the Azure SQL Database for vector similarity searches.

    ```JSON
    "result": {
    "object": "list",
    "data": [
      {
        "object": "embedding",
        "index": 0,
        "embedding": [
          0.009926898,
          0.042216457,
          -0.0139917405,
          -0.0063626235,
          0.008509632,
          -0.059923247,
          0.0271874,
          -0.019902045,
          0.024992144,
          -0.04006945,
          0.031915642,
            ...
    ```

## Store embeddings in the database

1. create a sample (temporary table) to hold some sample product information:

    ```SQL
    select top(10) id, product_name, [description], brand, category 
    into #t
    from [dbo].[walmart_product_details]
    order by id
    go

    alter table #t 
    add product_description_vector vector(1536) null;
    go
    ```

1. the code to call OpenAI to generate embedding given an input text has been encapsulated into the `create_embeddings` procedure to make it easier to be used in the next steps

1. generate the embedding and store them in the table

    ```SQL
    declare @i int = 1;
    declare @text nvarchar(max);
    declare @vector vector(1536);

    while @i <= 10
    begin
        set @text = (select isnull([product_name],'') + ': ' + isnull([Description],'') from #t  where id = @i);

        exec dbo.create_embeddings @text, @vector output;
        
        update #t set [product_description_vector] = @vector where id = @i;
        
        set @i = @i + 1;
    end
    ```

    > **WARNING** Please note that the above code is for demonstration purposes only, as it has been simplified to make it easier to understand.
    For production use, you should consider using a more efficient way to generate embeddings and store them in the database, taking into account
    batching requests to improve performance and reduce costs and also implement a retry-logic to make the solution resilient to failures or service back-offs.
    An example is provided here: https://github.com/Azure-Samples/azure-sql-db-vectorizer