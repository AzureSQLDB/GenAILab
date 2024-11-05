declare @i int = 1;
declare @text nvarchar(max);
declare @vector vector(1536);

while @i <= 30000
BEGIN
    set @text = (SELECT isnull([product_name],'') + ': ' + isnull([Description],'') from dbo.walmart_product_details where id = @i);
    exec dbo.create_embeddings @text, @vector output;
    update [dbo].[walmart_product_details] set [product_description_vector] = @vector where id = @i;
    set @i = @i + 1;
    if @i % 100 = 0
    begin
        WAITFOR DELAY '00:00:05'; -- wait for 5 seconds, every 100 items (to allow for OpenAI API rate limiting)
    end
END

