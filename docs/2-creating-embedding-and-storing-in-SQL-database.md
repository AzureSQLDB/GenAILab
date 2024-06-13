## Azure OpenAI Embeddings

An embedding is a special format of data representation that machine learning models and algorithms can easily use. The embedding is an information dense representation of the semantic meaning of a piece of text. Each embedding is a vector of floating-point numbers, such that the distance between two embeddings in the vector space is correlated with semantic similarity between two inputs in the original format. For example, if two texts are similar, then their vector representations should also be similar.

1. Copy the following SQL and paste it into the SQL query editor. You can see from the T-SQL that we are going to create an embedding for a product name from data in the Azure SQL Database. The query `SELECT [description] FROM [dbo].[walmart_product_details] WHERE id = 2` returns "**5.0 oz., 100% pre-shrunk cotton Athletic Heather .....**" and will be sent to the OpenAI REST endpoint.
 
    ```SQL
    declare @url nvarchar(4000) = N'https://mlads.openai.azure.com/openai/deployments/mladsembeddings/embeddings?api-version=2024-02-01';
    declare @headers nvarchar(300) = N'{"api-key": "OPENAI_KEY"}';
    declare @message nvarchar(max);
    SET @message = (SELECT [description]
                FROM [dbo].[walmart_product_details]
                WHERE id = 2);
    declare @payload nvarchar(max) = N'{"input": "' + @message + '"}';

    declare @ret int, @response nvarchar(max);

    exec @ret = sp_invoke_external_rest_endpoint 
        @url = @url,
        @method = 'POST',
        @headers = @headers,
        @payload = @payload,
        @timeout = 230,
        @response = @response output;

    select @ret as ReturnCode, @response as Response;
    ```

1. Replace the **OPENAI_KEY** text with the Model Deployment Key.

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