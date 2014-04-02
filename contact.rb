# Our Contact class is going to hold our user attributes (name, email, notes) as well as some auto-generated stuff
# (date created, modified, ID)
class Contact
  @@counter = 100

  attr_accessor :name, :email, :notes, :id, :attributes, :created, :modified
  
  def initialize(name, email, note)
    Contact.increase_count

    @name = name.to_s
    @email = email.to_s
    @notes = note

    @id = @@counter
    @created = time_format(Time.new)
    @modified = @created

    # build_contact_hash
  end

  # def build_contact_hash
  #   @attributes = {
  #     name: @name,
  #     email: @email,
  #     notes: @notes,
  #   } 
  # end

  def time_format(t_obj)
    "#{t_obj.day}-#{t_obj.month}-#{t_obj.year} at #{t_obj.hour}:#{t_obj.min}:#{t_obj.sec}"
  end

  # def to_s
  #   contact_string = "\n>>> Contact # #{@id} <<<\n"
  #   contact_string += "\nName: #{@name}" unless @name.empty?
  #   contact_string += "\nEmail Address: #{@email}" unless @email.empty?
  #   contact_string += "\n\nNotes: \n#{@notes}" unless @notes.empty?
  #   contact_string += "\n\n   Created on #{time_format(@created)}."
  #   contact_string += "\n   Last Modified: #{time_format(@modified)}."
  #   contact_string += "\n\n----------------------------"
  #   contact_string
  # end

  def self.increase_count
    @@counter += 1
  end

end