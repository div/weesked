module Weesked

  class DateNotRecognized < StandardError; end
  class NotAvailiable
    def day; nil; end
    def steps; nil; end
  end

  class DayBuilder

    MINUTES_IN_HOUR = 60
    SECONDS_IN_MINUTE = 60
    SECONDS_IN_HOUR = MINUTES_IN_HOUR * SECONDS_IN_MINUTE

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
        return NotAvailiable.new unless Weesked.availiable_steps.include? step
        # if false
        #   if wd == SUNDAY
        #     wd = SATURDAY
        #   else
        #     wd -= 1
        #   end
        # end
        Day.new(wd, step)
      end

      def build_from_date_range
        return NotAvailiable.new unless dates.begin.day == dates.end.day
        start = build_from_single_date dates.begin
        ending = build_from_single_date dates.end
        i_start = Weesked.availiable_steps.index start.steps.first
        i_end = Weesked.availiable_steps.index ending.steps.first
        Day.new start.day, Weesked.availiable_steps.slice(i_start..i_end)
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