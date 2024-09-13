-- OPEN AI, eg: 'https://mlads.openai.azure.com/openai
drop database scoped credential [https://<endpoint_1>/]

if not exists(select * from sys.database_scoped_credentials where [name] = 'https://<endpoint_1>/')
begin
    create database scoped credential [https://<endpoint_1>/]
    with identity = 'HTTPEndpointHeaders', secret = '{"api-key":"<api-key-1>"}';
end
go