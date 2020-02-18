require 'active_model'

class Organization
  include ActiveModel::Serializers::JSON

  ATTRIBUTES =[ :_id, :url, :external_id, :name, :domain_names,
    :created_at, :details, :shared_tickets, :tags]
  
  attr_accessor *ATTRIBUTES

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value.to_s)
    end
  end


  def attributes
    instance_values
  end

end