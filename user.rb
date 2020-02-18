require 'active_model'

class User
  include ActiveModel::Serializers::JSON

  ATTRIBUTES = [:_id, :url, :external_id, :name, 
    :alias, :created_at, :active, :verified, :shared, 
    :locale, :timezone, :last_login_at, :email, :phone, 
    :signature, :organization_id, :tags , :suspended, :role ]

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