require 'active_model'

class Ticket
  include ActiveModel::Serializers::JSON

  ATTRIBUTES =[ :_id, :url, :external_id, :created_at, :type,
  :subject, :description, :priority, :status, :submitter_id,
  :assignee_id, :organization_id, :tags, :has_incidents, :due_at,
  :via]

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