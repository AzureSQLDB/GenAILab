declare @search_text nvarchar(max) = 'help me plan a high school graduation party'

declare @search_vector vector(1536)

exec dbo.create_embeddings @search_text, @search_vector output;

declare @search_output nvarchar(max);

select 
    @search_output = string_agg(cast(t.[id] as varchar(10)) +'=>' + t.[product_name] + '=>' + t.[description], char(13) + char(10))
from 
(SELECT TOP(10) 
  id, product_name, description, 
  vector_distance('cosine', @search_vector, product_description_vector) AS distance
FROM [dbo].[walmart_product_details]
ORDER BY distance) as t

--select @search_output

declare @llm_payload nvarchar(max);


set @llm_payload = 
json_object(
    'messages': json_array(
            json_object(
                'role':'system',
                'content':'
                    You are an awesome AI shopping assistant  tasked with helping users find appropriate items they are looking for the occasion. 
                    You have access to a list of products, each with an ID, product name, and description, provided to you in the format of "Id=>Product=>Description". 
                    When users ask for products for specific occasions, you can leverage this information to provide creative and personalized suggestions. 
                    Your goal is to assist users in planning memorable celebrations using the available products.
                '
            ),
            json_object(
                'role':'user',
                'content': '## Source ##
                    ' + @search_output + '
                    ## End ##

                    Your answer needs to be a json object with the following format.
                    {
                        "answer": // the answer to the question, add a source reference to the end of each sentence. Source reference is the product Id.
                        "products": // a comma-separated list of product ids that you used to come up with the answer.
                        "thoughts": // brief thoughts on how you came up with the answer, e.g. what sources you used, what you thought about, etc.
                    }'
            ),
            json_object(
                'role':'user',
                'content': + @search_text
            )
    ),
    'max_tokens': 800,
    'temperature': 0.3,
    'frequency_penalty': 0,
    'presence_penalty': 0,
    'top_p': 0.95,
    'stop': null
);

--select @llm_payload



declare @retval int, @response nvarchar(max);

exec @retval = sp_invoke_external_rest_endpoint
    @url = 'https://<endpoint_2>/openai/deployments/d-completion/chat/completions?api-version=2024-05-01-preview',
    @headers = '{"Content-Type":"application/json"}',
    @method = 'POST',
    @credential = [https://<endpoint_2>/],
    @timeout = 120,
    @payload = @llm_payload,
    @response = @response output;

select @retval as 'Return Code', @response as 'Response';

select [key], [value] 
from openjson(( 
    select t.value 
    from openjson(@response, '$.result.choices') c cross apply openjson(c.value, '$.message') t
    where t.[key] = 'content'
))