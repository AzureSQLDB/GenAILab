/*
	Cleanup if needed
*/
if exists(select * from sys.[external_data_sources] where name = 'openai_playground')
begin
	drop external data source [openai_playground];
end
go
if exists(select * from sys.[database_scoped_credentials] where name = 'openai_playground')
begin
	drop database scoped credential [openai_playground];
end
go

/*
	Create database scoped credential and external data source.
	File is assumed to be in a path like: 
	https://<myaccount>.blob.core.windows.net/playground/wikipedia/vector_database_wikipedia_articles_embedded.csv

	Please note that it is recommened to avoid using SAS tokens: the best practice is to use Managed Identity as described here:
	https://learn.microsoft.com/en-us/sql/relational-databases/import-export/import-bulk-data-by-using-bulk-insert-or-openrowset-bulk-sql-server?view=sql-server-ver16#bulk-importing-from-azure-blob-storage
*/
create database scoped credential [openai_playground]
with identity = 'Managed Identity'
go
create external data source [openai_playground]
with 
( 
	type = blob_storage,
 	location = 'https://<ACCOUNT>.blob.core.windows.net/playground',
 	credential = [openai_playground]
);
go