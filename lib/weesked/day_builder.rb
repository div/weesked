require 'pry'
module Weesked

  class DateNotRecognized < StandardError; end
  class NotAvailiable < StandardError; end

  class DayBuilder

    def initialize dates
      @dates = dates
    end

    def run
      if dates.kind_of? Range
        build_from_date_range
      elsif dates.kind_of? Time
        build_from_single_date
      else
        raise DateNotRecognized
      end
    end

    private

      attr_reader :dates

      def build_from_single_date date=dates
        wd = date.wday
        time = beginning_of_step date
        step = step_index time
        raise NotAvailiable unless Weesked.availiable_steps.include? step
        if step < Weesked.steps_day_shift
          if wd == SUNDAY
            wd = SATURDAY
          else
            wd -= 1
          end
        end
        Day.new(wd, step)
      end

      def build_from_date_range
        start = build_from_single_date dates.begin
        ending = build_from_single_date dates.end
        raise NotAvailiable unless start.day == ending.day
        i_start = Weesked.availiable_steps.index start.steps.first
        i_end = Weesked.availiable_steps.index ending.steps.first
        array = if Weesked.steps_day_shift > 0 && i_start > i_end
          Weesked.availiable_steps.slice(i_start..-1) + Weesked.availiable_steps.slice(0..i_end)
        else
          Weesked.availiable_steps.slice(i_start..i_end)
        end
        Day.new start.day, array
      end

      def beginning_of_step time
        (seconds_since_midnight(time) / Weesked.time_step) * Weesked.time_step
      end

      def step_index seconds
        seconds / Weesked.time_step
      end

      def seconds_since_midnight time
        time.hour * SECONDS_IN_HOUR + time.min * SECONDS_IN_MINUTE + time.sec
      end
  end

end