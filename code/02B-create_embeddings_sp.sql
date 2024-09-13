create or alter procedure dbo.create_embeddings
(
    @input_text nvarchar(max),
    @embedding vector(1536) output
)
AS
BEGIN
-- declare @text nvarchar(max) = (SELECT isnull([product_name],'') + ': ' + isnull([Description],'') from dbo.walmart_product_details where id = 25898)
declare @url varchar(max) = 'https://<endpoint>/openai/deployments/embeddings/embeddings?api-version=2023-03-15-preview';
declare @payload nvarchar(max) = json_object('input': @input_text);
declare @response nvarchar(max);
declare @retval int;

-- Call to OpenAI to get the embedding of the search text
begin try
    exec @retval = sp_invoke_external_rest_endpoint
        @url = @url,
        @method = 'POST',
        @credential = [https://<endpoint>/],
        @payload = @payload,
        @response = @response output;
end try
begin catch
    select 
        'SQL' as error_source, 
        error_number() as error_code,
        error_message() as error_message
    return;
end catch

if (@retval != 0) begin
    select 
        'OPENAI' as error_source, 
        json_value(@response, '$.result.error.code') as error_code,
        json_value(@response, '$.result.error.message') as error_message,
        @response as error_response
    return;
end

-- Parse the embedding returned by Azure Open AI
declare @json_embedding nvarchar(max) = json_query(@response, '$.result.data[0].embedding');

-- Convert the JSON array to a vector and set return parameter
set @embedding = CAST(@json_embedding AS VECTOR(1536));

END;