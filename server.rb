require_relative 'contact'
require_relative 'rolodex'
require 'sinatra'

def app_name
  "Customer Relationship Management"
end

@@rolodex = Rolodex.new

@@rolodex.new_contact("Joshua Comeau", "joshwcomeau@gmail.com", ["It's me! I created this neat little thing right?", "note 2"])
@@rolodex.new_contact("James Dean", "singer@gmail.com", ["One of those celebrity people from before I was born."])
@@rolodex.new_contact("Barack Obama", "president@usa.gov", ["43rd President of the United States. Should have hired me to make the ObamaCare website (I couldn't have done worse)."])


#### ROUTES ####
get "/" do  
  @app_name = app_name
  erb :index 

end

get "/add" do    # View the 'add contact' page
  @app_name = app_name
  erb :new
end

get "/contacts" do        # View all contacts
  @app_name = app_name
  erb :contacts
end

# get "/contacts/:id" do        # View a contact
#   @contact = @@rolodex.grab_contact(:id.to_s)
#   erb :view
# end

get "/contacts/:id/edit" do   # Edit a contact
  id = params[:id].to_i
  @app_name = app_name
  @contact = @@rolodex.grab_contact(id)


  erb :view
end

post "/contacts/confirm" do       # Post a new contact
  @app_name = app_name
  @name = params[:first_name]
  @email = params[:email]
  notes_fields = [:notes1, :notes2, :notes3, :notes4]
  @notes = []


  notes_fields.each do |field|
    @notes << params[field] unless params[field].empty?
  end

  @@rolodex.new_contact(@name, @email, @notes)
  @id = @@rolodex.get_id_by_name(@name)

  erb :confirm
end

post "/contacts/savechanges" do
  puts params
  puts "/n/n/n"
  @contact = @@rolodex.grab_contact(params["id"].to_i)
  @note_fields = ["note_1", "note_2", "note_3", "note_4", "note_5"]
  @new_notes = []

  @note_fields.each do |field|
    if params[field] != '' || params[field] != nil
      @new_notes << params[field]
    end
  end

  @name = params["first_name"]
  @email = params["email"]
  @id = params["id"].to_i

  # Validate Email

  @contact.name = @name
  @contact.email = @email
  @contact.notes = @new_notes
  

  erb :confirm


end





