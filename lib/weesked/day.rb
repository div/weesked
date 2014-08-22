module Weesked
  class WrongDay < StandardError; end
  class Day
    attr_reader :day

    def self.build date
      DayBuilder.new(date).run
    end

    def initialize(day, steps=[])
      @steps = steps
      @day = if day.kind_of?(Integer)
        Weesked.availiable_days.fetch(day.to_i).to_sym
      else
        raise WrongDay unless Weesked.availiable_days.include?(day.to_s)
        day.to_sym
      end
    end

    def steps
      steps = (Array(@steps)- ['', nil]).map(&:to_i)
      Weesked.availiable_steps&steps
    end
  end
end