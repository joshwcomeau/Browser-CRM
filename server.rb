require_relative 'rolodex'
require 'sinatra'
require 'data_mapper'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3:database.sqlite3")


class Contact
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :notes1, String
  property :notes2, String
  property :notes3, String
  property :notes4, String
  property :notes5, String

  property :created_at, DateTime
  property :updated_at, DateTime

  DataMapper.finalize
  DataMapper.auto_upgrade!

end

class Notes
  include DataMapper::Resource

  property :id, Serial
  property :fid, Serial

end

@@rolodex = Rolodex.new
@@app_name = "Customer Relations Management"

# Some sample contacts
# Contact.create(
#   name: "Joshua Comeau",
#   email: "joshwcomeau@gmail.com",
#   notes1: "Got to school 5 minutes early today!",
#   notes2: "What a trooper",
#   notes3: "",
#   notes4: "",
#   notes5: ""
# )



#### FUNCTIONS ####
def gather_notes(data)
  notes_fields = [:notes1, :notes2, :notes3, :notes4, :notes5]
  notes = []
  notes_fields.each do |field|
    notes << params[field] unless params[field].empty?
  end

  notes
end

#### ROUTES ####
get "/" do  
  erb :index 

end

get "/add" do    # View the 'add contact' page
  erb :new
end

get "/contacts" do        # View Contacts
  # View All
  if params.empty?
    @results = Contact.all
    @header_msg = "Viewing All Contacts"

  #View Search Results
  else
    @term = params[:search] 

    @results =  Contact.all(id: @term) +
                Contact.all(:name.like => "%"+@term+"%") +
                Contact.all(:email.like => "%"+@term+"%") +
                Contact.all(:notes1.like => "%"+@term+"%") +
                Contact.all(:notes2.like => "%"+@term+"%") +
                Contact.all(:notes3.like => "%"+@term+"%") +
                Contact.all(:notes4.like => "%"+@term+"%") +
                Contact.all(:notes5.like => "%"+@term+"%")
                
    @header_msg = "Search Results:"
    @results_num = @results.length
  end

  erb :contacts
end

get "/contacts/:id/edit" do   # View Contact (editable)
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :view
  else
    raise Sinatra::NotFound
  end
end

post "/contacts/confirm" do       # Post a new contact or restore deleted

  @id = params[:id] # Only set when restoring deletions

  @name = params[:first_name]
  @email = params[:email]
  @notes1 = params[:notes1]
  @notes2 = params[:notes2]
  @notes3 = params[:notes3]
  @notes4 = params[:notes4]
  @notes5 = params[:notes5]

  @action = params[:action]

  @contact = Contact.create(
    name: @name,
    email: @email,
    notes1: @notes1,
    notes2: @notes2,
    notes3: @notes3,
    notes4: @notes4,
    notes5: @notes5
  )
  # If we're creating a new contact:
  if @action == 'create'
    
    @id = @contact.id
    @action_message = "Contact Created!"
    erb :confirm

  elsif @action == 'restore'
    @contact.id = @id         # Restore the old ID
    @contact.save             # Save!

    @action_message = "Contact Restored!"

    @restored = true
    @results = Contact.all
    erb :contacts
  end
end

put "/contacts/savechanges" do    # Save changes to an edited contact

  @id = params[:id].to_i
  @name = params[:first_name]
  @email = params[:email]
  @notes1 = params[:notes1]
  @notes2 = params[:notes2]
  @notes3 = params[:notes3]
  @notes4 = params[:notes4]
  @notes5 = params[:notes5]

  @contact = Contact.get(@id)

  @contact.name = @name
  @contact.email = @email
  @contact.notes1 = @notes1
  @contact.notes2 = @notes2
  @contact.notes3 = @notes3
  @contact.notes4 = @notes4
  @contact.notes5 = @notes5


  @contact.save

  
  erb :confirm

end

delete "/contacts/:id/delete" do
  @contact = Contact.get(params[:id].to_i)

  # Store data in instance variables before deletion for 'undo' function
  @id = @contact.id
  @name = @contact.name
  @email = @contact.email
  @notes1 = @contact.notes1
  @notes2 = @contact.notes2
  @notes3 = @contact.notes3
  @notes4 = @contact.notes4
  @notes5 = @contact.notes5

  if @contact
    @contact.destroy
    @deleted = true
    @results = Contact.all

    erb :contacts
  else
    raise Sinatra::NotFound
  end
end




