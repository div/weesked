require File.expand_path('../version', __FILE__)

module Weesked
  module Configuration
    VALID_OPTIONS_KEYS = [
      :time_step,
      :availiable_days,
      :availiable_steps,
      :steps_day_shift,
      # :redis
    ].freeze


    # By default, 1.hour
    DEFAULT_TIME_STEP = 3600

    # By default, the whole week
    DEFAULT_AVAILIABLE_DAYS = %w(sunday monday tuesday wednesday thursday friday saturday)

    # By default, whole day in hours
    DEFAULT_AVAILIABLE_STEPS = (0..24).to_a

    # By default, we use astonomical day
    DEFAULT_STEPS_DAY_SHIFT = 0

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.time_step = DEFAULT_TIME_STEP
      self.availiable_days = DEFAULT_AVAILIABLE_DAYS
      self.availiable_steps = DEFAULT_AVAILIABLE_STEPS
      self.steps_day_shift = DEFAULT_STEPS_DAY_SHIFT
    end
  end
end
