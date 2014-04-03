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
@@app_name = app_name

#### FUNCTIONS ####
def gather_notes(data)
  notes_fields = [:notes1, :notes2, :notes3, :notes4, :notes5]
  notes = []
  notes_fields.each do |field|
    notes << params[field] unless params[field].empty?
  end

  notes
end

# redirect to('/contacts')

#### ROUTES ####
get "/" do  
  erb :index 

end

get "/add" do    # View the 'add contact' page
  erb :new
end

get "/contacts" do        # View all contacts
  if params.empty?
    @results = @@rolodex.contacts
    @header_msg = "Viewing All Contacts"
  else
    @results = @@rolodex.contacts.select do |contact|
      string = contact.name + contact.email
      contact.notes.each do |note|
        string += note
      end
      string.downcase.include?(params[:search].downcase)
    end
    @header_msg = "Search Results:"
    @results_num = @results.length
  end

  erb :contacts
end

get "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id/edit" do   # View or Edit a contact
  id = params[:id].to_i
  @contact = @@rolodex.grab_contact(id)



  erb :view
end

post "/contacts/confirm" do       # Post a new contact
  puts params
  @name = params[:first_name]
  @email = params[:email]
  
  @notes = gather_notes(params)


  

  @@rolodex.new_contact(@name, @email, @notes)
  @id = @@rolodex.get_id_by_name(@name)

  erb :confirm
end

post "/contacts/savechanges" do
  puts params
  puts "/n/n/n"
  @contact = @@rolodex.grab_contact(params["id"].to_i)

  @notes = gather_notes(params)
  @name = params["first_name"]
  @email = params["email"]
  @id = params["id"].to_i


  @contact.name = @name
  @contact.email = @email
  @contact.notes = @notes
  

  erb :confirm


end





