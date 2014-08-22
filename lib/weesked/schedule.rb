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

      def weesked_schedule_key(day, step)
        "weesked:availiability:#{self.name.downcase}:#{day}:#{step}"
      end

      def availiable date
      end

    end

    module InstanceMethods
      def redis
        self.class.redis
      end

      def schedule=(availiability_hash)
        update_schedule_for_instance availiability_hash
        update_schedule_for_class
      end

      def schedule
        Weesked.availiable_days.each_with_object(Hash.new) do |day, h|
          h[day.to_sym] = redis.smembers(weesked_key(day)).map(&:to_i)
        end
      end

      def availiable? date
      end

      def weesked_key(day)
        raise NilDay unless day
        if id.nil?
          raise NilObjectId,
            "Weesked schedule on class #{self.class.name} with nil id (unsaved record?) [object_id=#{object_id}]"
        end
        day = Day.new(day).day
        "weesked:#{self.class.name.downcase}:#{id}:#{day}"
      end

      private

        def update_schedule_for_class
          sch = schedule
          redis.multi do
            Weesked.availiable_days.each do |day|
              Weesked.availiable_steps.each do |step|
                redis.srem self.class.weesked_schedule_key(day, step), id
                redis.sadd self.class.weesked_schedule_key(day, step), id if sch[day.to_sym].include?(step)
              end
            end
          end
        end

        def update_schedule_for_instance hash
          redis.multi do
            Weesked.availiable_days.each do |d|
              redis.del weesked_key(d)
              steps = hash.fetch d.to_sym
              day = Day.new d, steps
              redis.sadd(weesked_key(d), day.steps) if day.steps.any?
            end
          end
        end

    end
  end
end