/*
if exists(select * from sys.[database_scoped_credentials] where name = '[https://<account>.openai.azure.com/openai] ')
begin
	drop database scoped credential [https://<account>.openai.azure.com/openai];
end
*/

create database scoped credential [https://<OPENAI_ACCOUNT>.openai.azure.com/openai] 
with identity = 'HTTPEndpointHeaders', secret = N'{"api-key":"OPENAI_KEY"}';