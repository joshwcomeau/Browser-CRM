require_relative 'contact'
require 'sinatra'

def app_name
  "Customer Relationship Management"
end

get "/" do  
  @app_name = app_name
  erb :index 

end

# Add a contact

get "/contacts/new" do
  @app_name = app_name
  erb :new
end

# View all contacts
get "/contacts" do
  @app_name = app_name
  @contacts = []
  @contacts << Contact.new("Joshhjkferhfe","twoequalsone@live.com","it's me!")
  @contacts << Contact.new("Harold Owens", "guy@hotmail.com", "I think he's an author?")
  @contacts << Contact.new("Joshhjkferhfe","twoequalsone@live.com","it's me!")
  @contacts << Contact.new("Harold Owens", "guy@hotmail.com", "I think he's an author?")
  @contacts << Contact.new("Joshhjkferhfe","twoequalsone@live.com","it's me!")
  @contacts << Contact.new("Harold Owens", "guy@hotmail.com", "I think he's an author?")
  @contacts << Contact.new("Allain Davies", "brit@gmail.com", "yeah, him.")
  erb :contacts
end

# View a contact
get "/contacts/:id" do
  erb :view
end

# Edit a contact
get "/contacts/:id/edit" do
  erb :edit
end
