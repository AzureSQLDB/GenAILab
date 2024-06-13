![A picture of the Microsoft Logo](./media/graphics/microsoftlogo.png)

# Using Azure OpenAI Service

![A picture of the Azure OpenAI Service logo](./media/ch6/azureopenai.png)

## Azure OpenAI Service

Azure OpenAI Service provides REST API access to OpenAI's powerful language models including the GPT-4, GPT-4 Turbo with Vision, GPT-3.5-Turbo, and Embeddings model series. In addition, the new GPT-4 and GPT-3.5-Turbo model series have now reached general availability. These models can be easily adapted to your specific task including but not limited to content generation, summarization, image understanding, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the Azure OpenAI Studio.

Azure OpenAI Service is powered by a diverse set of models with different capabilities:


|Models	|Description|
--------|-----------|
|GPT-4o & GPT-4 Turbo [NEW!]| The latest most capable Azure OpenAI models with multimodal versions, which can accept both text and images as input.|
|GPT-4 | A set of models that improve on GPT-3.5 and can understand and generate natural language and code.|
|GPT-3.5 | A set of models that improve on GPT-3 and can understand and generate natural language and code.|
|Embeddings	| A set of models that can convert text into numerical vector form to facilitate text similarity.|
|DALL-E	| A series of models that can generate original images from natural language.|
|Whisper | A series of models in preview that can transcribe and translate speech to text.|
|Text to speech (Preview) |	A series of models in preview that can synthesize text to speech.|

**Table 1:** Azure OpenAI Models

## Azure OpenAI DALL-E 3

The image generation API creates an image from a text prompt.

1. Copy the following SQL and paste it into the SQL query editor. Like the previous example, the query here 'SELECT [Description] FROM [SalesLT].[ProductDescription] WHERE ProductDescriptionID = 457' returns a product description "**This bike is ridden by race winners. Developed with the Adventure Works Cycles professional race team, it has a extremely light heat-treated aluminum frame, and steering that allows precision control.**" which will be sent to the DALL-E 3 text to image endpoint.

    ```SQL
    declare @url nvarchar(4000) = N'https://mlads.openai.azure.com/openai/deployments/mlads_dalle/images/generations?api-version=2024-05-01-preview';
    declare @headers nvarchar(300) = N'{"api-key": "OPENAI_KEY"}';
    declare @message nvarchar(max);
    SET @message = (SELECT [description]
                FROM [dbo].[walmart_product_details]
                WHERE id = 2);
    declare @payload nvarchar(max) = N'{
        "prompt": "' + @message + '",
        "size": "1024x1024",
        "n": 1
    }';

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

    ![An image created by Azure OpenAI DALL-E 3](./media/ch5/generated_00.png)

1. Now, you are in charge. Either select a new product description ID or try creating an image yourself! Here is some inspiration:

    ![An image created by Azure OpenAI DALL-E 3](./media/ch5/image2.png)

## Azure OpenAI GPT-4o

Let's use the new GPT-4o model for this next call. We are going to ask it to describe a picture you make using the above DALL-E 3 endpoint. So to start, go wild and ask it to create you some fantastical image. Once you have that URL, we are going to use it in our REST call.

1. Copy the following SQL and paste it into the SQL query editor. 

    ```SQL
    declare @url nvarchar(4000) = N'https://mlads.openai.azure.com/openai/deployments/mladsgpt4o/chat/completions?api-version=2024-02-15-preview';
    declare @headers nvarchar(102) = N'{"api-key":"OPENAI_KEY"}';
    declare @payload nvarchar(max) = N'{
        "messages": [
            {
                "role": "system",
                "content": "You are an AI assistant that helps people find information."
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "what is this an image of?"
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": "DALLE3_IMAGE_URL"
                        }
                    }
                ]
            }
        ]
    }';
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
1. Replace the **OPENAI_KEY** text with the Model Deployment Key. Also, replace the **DALLE3_IMAGE_URL** with the url of the fantastical image you just created.

1. Execute the SQL statement with the run button.

1. View the return message and see if the new GPT-4o model was able to describe it.

    ```JSON
                "message": {
                    "content": "This is an image of a bright green t-shirt with short sleeves. It has a small black graphic on the left chest area, which appears to be an abstract or stylized design. The neckline is round and there’s a hint of a tag visible through the collar. The hem at the bottom of the shirt also features a black trim.",
                    "role": "assistant"
                }
    ```
