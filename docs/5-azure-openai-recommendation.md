# Using Azure OpenAI Service

![A picture of the Azure OpenAI Service logo](./media/ch5/azureopenai.png)

## Azure OpenAI Service

Azure OpenAI Service provides REST API access to OpenAI's powerful language models including the GPT-4, GPT-4 Turbo with Vision, GPT-3.5-Turbo, and Embeddings model series. In addition, the new GPT-4 and GPT-3.5-Turbo model series have now reached general availability. These models can be easily adapted to your specific task including but not limited to content generation, summarization, image understanding, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the Azure OpenAI Studio.

Azure OpenAI Service is powered by a diverse set of models with different capabilities, for example:


|Models	|Description|
--------|-----------|
|GPT-4o & GPT-4 Turbo| The latest most capable Azure OpenAI models with multimodal versions, which can accept both text and images as input.|
|GPT-4 | A set of models that improve on GPT-3.5 and can understand and generate natural language and code.|
|GPT-3.5 | A set of models that improve on GPT-3 and can understand and generate natural language and code.|
|Embeddings	| A set of models that can convert text into numerical vector form to facilitate text similarity.|
|DALL-E	| A series of models that can generate original images from natural language.|
|Whisper | A series of models in preview that can transcribe and translate speech to text.|
|Text to speech (Preview) |	A series of models in preview that can synthesize text to speech.|

**Table 1:** Azure OpenAI Models

## Azure ChatGPT-4

You want to find help customers to find the best set of products for somthing, for example to organize an high-school graduation party.

1. Copy the following SQL and paste it into the SQL query editor.

    ```SQL
    declare @search_text nvarchar(max) = 'help me plan a high school graduation party'

    -- Get the search vector for the search text
    declare @search_vector vector(1536)
    exec dbo.create_embeddings @search_text, @search_vector output;

    -- Get the top 50 products that are closest to the search vector
    drop table if exists #t;
    with cte as 
    (
        select         
            id, product_name, [description], product_description_vector,        
            row_number() over (partition by product_name order by id ) as rn
        from 
            [dbo].[walmart_product_details]
        where 
            available = 'TRUE'
    ), 
    cte2 as -- remove duplicates
    (
        select 
            *
        from
            cte 
        where
            rn = 1
    )
    select top(50)
        id, product_name, [description],
        vector_distance('cosine', @search_vector, product_description_vector) as distance
    into
        #t
    from 
        cte2
    order by 
        distance;

    -- Aggregate the search results to make them easily consumable by the LLM
    declare @search_output nvarchar(max);
    select 
        @search_output = string_agg(cast(t.[id] as varchar(10)) +'=>' + t.[product_name] + '=>' + t.[description], char(13) + char(10))
    from 
        #t as t;

    -- Generate the payload for the LLM
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

    -- Invoke the LLM to get the response
    declare @retval int, @response nvarchar(max);
    declare @headers nvarchar(300) = N'{"api-key": "OPENAI_KEY", "content-type": "application/json"}';
    exec @retval = sp_invoke_external_rest_endpoint
        @url = 'https://mlads.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2023-03-15-preview',
        @headers = @headers,
        @method = 'POST',    
        @timeout = 120,
        @payload = @llm_payload,
        @response = @response output;
    select @retval as 'Return Code', @response as 'Response';

    -- Get the answer from the response
    select [key], [value] 
    from openjson(( 
        select t.value 
        from openjson(@response, '$.result.choices') c cross apply openjson(c.value, '$.message') t
        where t.[key] = 'content'
    ))
    ```

1. Replace the **OPENAI_KEY** text with the Model Deployment Key. 

1. Execute the SQL statement with the run button.

1. View the return message and see what the gpt-4 model was able to recommnend. Try using different search phrases. For example for the question: *"I am looking for a gift for my friend who is a foodie. She loves to cook and bake. She is always trying out new recipes and experimenting with different ingredients. I want to get her something that will inspire her creativity in the kitchen. Do you have any suggestions?"*, you may get:

    *"For a friend who loves to cook and experiment in the kitchen, consider the 'Growing up in a Korean Kitchen : A Cookbook' which offers a blend of memoir and recipes, perfect for exploring traditional and modern Korean dishes (7779). Another great choice could be 'The New Whole Foods Encyclopedia', a comprehensive resource for selecting, preparing, and using whole foods, which can inspire new culinary creations (10947). For a touch of fun and practicality, the 'Best Choice Products Mason Jars w/Labeling Stickers & Chalk, Set of 5' would be perfect for storing spices or homemade jams (7579)".*



