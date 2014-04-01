require 'sinatra'


get "/" do
  @app_name = "Customer Relationship Management"
  erb :index 
end
