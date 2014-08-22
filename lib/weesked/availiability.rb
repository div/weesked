module Weesked
  module Availiability

    class << self
      def included(klass)
        klass.send :include, InstanceMethods
        klass.extend ClassMethods
      end
    end

    module ClassMethods

      def availiability range
        keys = range_keys range
        if keys.empty?
          []
        else
          redis.sinter *keys
        end
      end

      def range_keys range
        keys = []
        day = Day.build range
        return keys unless day.steps
        day.steps.each do |step|
          keys << self.weesked_schedule_key(day.day, step)
        end
        keys
      end

    end

    module InstanceMethods
      def availiable? range
        self.class.availiability(range).include?(id.to_s)
      end
    end

  end
end
