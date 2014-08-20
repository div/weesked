require File.expand_path("../../test_helper", __FILE__)

module Weesked
  describe DayBuilder do


    describe '#run' do
      describe 'converts single datetime to Day' do
        let(:sunday)    { Time.local(2020, 'jan', 5, hour, 17) }
        let(:monday)    { Time.local(2020, 'jan', 6, hour, 12) }
        let(:wednesday) { Time.local(2020, 'jan', 8, hour, 13) }

        describe 'with day hours' do
          let(:hour) { 14 }

          [:sunday, :monday, :wednesday].each do |day|
            subject { DayBuilder.new(eval(day.to_s)).run }
            it 'is a Day' do
              subject.must_be_instance_of Day
            end
            it "has correct weekday: #{day}" do
              subject.day.must_equal day
            end
            it 'has correct step' do
              subject.steps.must_equal [ hour ]
            end
          end

        end

        # describe 'with night' do
        #   let(:hour) { 2 }
        #   it 'works for sunday' do
        #     builder = DayBuilder.new sunday
        #     builder.run.day.must_equal :saturday
        #     builder.run.hours.must_equal [ hour ]
        #   end

        #   it 'works for monday' do
        #     builder = DayBuilder.new monday
        #     builder.run.day.must_equal :sunday
        #     builder.run.hours.must_equal [ hour ]
        #   end

        #   it 'works for wednesday' do
        #     builder = DayBuilder.new wednesday
        #     builder.run.day.must_equal :tuesday
        #     builder.run.hours.must_equal [ hour ]
        #   end
        # end

        # describe 'handles unavailiable times' do
        #   let(:hour) { 4 }
        #   [:sunday, :monday, :wednesday].each do |day|
        #     subject { DayBuilder.new(eval(day.to_s)).run }
        #     it "works for #{day}" do
        #       subject.must_be_instance_of NotAvailiable
        #     end
        #   end
        # end
     end

      describe 'converts date range to window' do

        describe 'with day hours' do
          let(:monday_day_range) { Time.local(2020, 'jan', 6, start_at)..Time.local(2020, 'jan', 6, end_at, 34) }
          let(:start_at) { 11 }
          let(:end_at) { 15 }
          subject { DayBuilder.new(monday_day_range).run }
          it 'works for monday' do
            subject.day.must_equal :monday
            subject.steps.must_equal (start_at..end_at).to_a
          end
        end

        # describe 'with night hours' do
        #   let(:monday_night_range) { Time.local(2020, 'jan', 6, start_at, 12)..Time.local(2020, 'jan', 7, end_at, 34) }
        #   let(:start_at) { 22 }
        #   let(:end_at) { 1 }
        #   subject { DayBuilder.new(monday_night_range).run }
        #   it 'works for night' do
        #     subject.day.must_equal :monday
        #     subject.hours.must_equal [22, 23, 0, 1]
        #   end
        # end

        describe 'with anavailiable hours' do
          let(:monday_night_range) { Time.local(2020, 'jan', 6, start_at, 12)..Time.local(2020, 'jan', 7, end_at, 34) }
          let(:start_at) { 1 }
          let(:end_at) { 4 }
          subject { DayBuilder.new(monday_night_range).run }
          it 'works for night' do
            subject.must_be_instance_of NotAvailiable
          end
        end

        describe 'with too long range' do
          let(:monday_night_range) { Time.local(2020, 'jan', 6, start_at, 12)..Time.local(2020, 'jan', 10, end_at, 34) }
          let(:start_at) { 22 }
          let(:end_at) { 1 }
          subject { DayBuilder.new(monday_night_range).run }
          it 'works for night' do
            subject.must_be_instance_of NotAvailiable
          end
        end
      end
    end
  end
end