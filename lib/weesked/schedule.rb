module Schedule

  class NotConnected < StandardError; end
  class NilObjectId  < StandardError; end

  class << self
    def redis=(conn)
      @redis = conn
    end
    def redis
      @redis || $redis || Redis.current ||
        raise(NotConnected, "Redis not set to a Redis.new connection")
    end

    def included(klass)
      klass.instance_variable_set('@redis', nil)
      klass.send :include, InstanceMethods
      klass.extend ClassMethods
    end
  end

  module ClassMethods
    attr_writer :redis
    def redis
      @redis || Schedule.redis
    end

    def redis_prefix=(redis_prefix) @redis_prefix = redis_prefix end
    def redis_prefix(klass = self)
      @redis_prefix ||= klass.name.to_s.
        sub(%r{(.*::)}, '').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        downcase
    end

  end

  module InstanceMethods
    def redis
      self.class.redis
    end

    def weesked_key
      if id.nil?
        raise NilObjectId,
          "Weesked schedule on class #{self.class.name} with nil id (unsaved record?) [object_id=#{object_id}]"
      end
      "#{redis_prefix(self.class)}:#{id}:#{name}"
    end

  end
end
