/*
    Import data from file
*/
bulk insert [dbo].[walmart_product_details_source]
from 'walmart/walmart-product-with-embeddings-dataset-usa.csv'
with (
	data_source = 'openai_playground',
    format = 'csv',
    firstrow = 2,
    codepage = '65001',
	fieldterminator = ',',
    rowterminator = '0x0a',
    fieldquote = '"',
    batchsize = 1000,
    tablock
)
go

/*
    Create a final table that make use of new vector type
*/
select 
    [id],
	[product_name],
	[description],
	[list_price],
	[sale_price],
	[brand],
	[item_number],
	[gtin],
	[package_size],
	[category],
	[available],
	[embedding]= cast([embedding] as vector(1536))
into
    [dbo].[walmart_product_details]
from 
    [dbo].[walmart_product_details_source]
go

alter table [dbo].[walmart_product_details]
add constraint pk__walmart_product_details primary key nonclustered (id)
go

