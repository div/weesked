module Weesked
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

      def schedule=(availiability_hash)
        @availiability_hash = availiability_hash
        replace_sitter_availiability
        replace_in_compound_availiability
      end

      def schedule
        @schedule = Availiability::DAYS.each_with_object(Hash.new) do |day, h|
          h[day.to_sym] = redis.smembers(key(day)).map(&:to_i)
        end
      end

      private

        def replace_in_compound_availiability
          sch = schedule
          redis.multi do
            Weesked.availiable_days.each do |day|
              Weesked.availiable_steps.each do |step|
                redis.srem Availiability.key(day, set), id
                redis.sadd Availiability.key(day, set), id if sch[day.to_sym].include?(set)
              end
            end
          end
        end

        def replace_availiability
          clear_availiability
          set_availiability
        end

        def clear_availiability
          redis.multi do
            Weesked.availiable_days.each do |day|
              redis.del key(day)
            end
          end
        end

        def set_availiability
          redis.multi do
            Weesked.availiable_days.each do |day|
              steps = availiability_hash.fetch day.to_sym
              window = Window.new day, steps
              redis.sadd(key(day), window.steps) if window.steps.any?
            end
          end
        end

    end
  end
end