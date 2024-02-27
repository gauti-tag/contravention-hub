module SessionManager
    def self.set_orange_date_month date
        REDIS_CLIENT.set("orange_base_date", date.to_s)
    rescue StandardError
        nil
    end

    def self.get_orange_date_month
        REDIS_CLIENT.get("orange_base_date")
    rescue StandardError
        nil
    end
    
    def self.set_orange_counter counter 
        REDIS_CLIENT.set("orange_counter", counter.to_s)
    rescue StandardError
        nil
    end
    
    def self.get_orange_counter
        REDIS_CLIENT.get("orange_counter")
    rescue StandardError
        nil
    end 
end