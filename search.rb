require 'json'
require './user'
require './ticket'
require './organization'

class Search
  attr_accessor :records, :search_field, :search_keyword, :search_type

  SEARCH_TYPE_DIR = {
    1 => {name: 'users', method: 'initialize_users'},
    2 => {name: 'tickets', method: 'initialize_tickets'},
    3 => {name: 'organizations', method: 'initialize_organizations'} 
  }

  def initialize
    @records = []
    command = 'start'
    while command != "quit" do
      puts "Welcome to Zendesk Search\n"
      puts "Type 'quit' to Exit at any time, Press 'Enter' to continue"
      command = gets.chomp

      if command == "quit"
        puts "Thank you! Have a good day"
        break
      elsif command == ""
        puts "Select search option\n"
        puts "* Press 1 to search zendesk"
        puts "* Press 2 to view a list of searchable fields"
        puts "* Type 'quit' to Exit"
        command = gets.chomp
        if command == '1'
          puts "Select 1) User or 2) Ticket or 3) Organization"
          @search_type = gets.chomp
          puts "Enter Search Term"
          @search_field = gets.chomp
          puts "Enter Search value"
          @search_keyword = gets.chomp

          send SEARCH_TYPE_DIR[@search_type.to_i][:method]

          execute
        elsif command == '2'
          print_attributes_list
        elsif command == "quit"
          puts "Thank you! Have a good day"
          break
        end
      end
      puts "-----------------------------------------\n\n\n"
    end
  end

  def execute
    puts "Searching for #{SEARCH_TYPE_DIR[@search_type.to_i][:name]} for #{@search_field} with a value of #{@search_keyword}"
    result = @records.find do |record| 
      if @search_field == "tags"
        record.tags.include?(@search_keyword)
      else
        record.send(@search_field) == @search_keyword
      end
    end
    
    if result
      print_result(result)
    else
      puts "No Results found"
    end
  end

  def initialize_users
    users_json = JSON.parse(File.read("./users.json"))
    map_json_to_objects(users_json, User)
  end

  def initialize_tickets
    tickets_json = JSON.parse(File.read("./tickets.json"))
    map_json_to_objects(tickets_json, Ticket)
  end

  def initialize_organizations
    organizations_json = JSON.parse(File.read("./organizations.json"))
    map_json_to_objects(organizations_json, Organization)
  end

  def map_json_to_objects(record_json, obj_class)
    record_json.each do |json|
      obj = obj_class.new
      @records << obj.from_json(json.to_json)
    end
  end

  def print_result(result)
    result.as_json.each do |key, value|
      puts "#{key} #{' ' * (30 - key.size)} #{value}"
    end
  end

  def print_attributes_list
    SEARCH_TYPE_DIR.each do |key, value|
      puts "-----------------------------------------------\n"
      puts "Search #{value[:name].capitalize} with\n"
      value[:name].classify.constantize::ATTRIBUTES.each {|attr| puts attr}
    end
  end
end

Search.new
