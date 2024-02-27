class RedisManager
  class << self

    def config_records(key:)
      config_model = key.to_s.camelize.constantize
      config_model.cached_records
    end

    def config_value(key:, code:)
      config_records(key: key).fetch(code.to_s.strip) { nil }
    end
  end
end