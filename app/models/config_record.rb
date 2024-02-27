class ConfigRecord < ApplicationRecord
  self.abstract_class = true

  include ActiveModel::AttributeAssignment

  def self.cached_records
    key = "#{name.underscore}s:#{Time.now.strftime("%Y-%m-%d")}"
    data = JSON.parse(REDIS_CLIENT.get(key)) rescue nil
    if data.blank?
      data = pluck(caching_key, :id).to_h
      REDIS_CLIENT.setex(key, 1.hour.to_i, data.to_json)
    end
    data
  end

  def self.caching_key
    :code
  end

end
