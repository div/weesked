require File.expand_path("../../test_helper", __FILE__)

module Weesked
  describe DayBuilder do


    describe '#run' do
      describe 'converts single datetime to Day' do


        let(:dates) {
          {
            sunday:     Time.local(2020, 'jan', 5, hour, 17),
            monday:     Time.local(2020, 'jan', 6, hour, 12),
            wednesday:  Time.local(2020, 'jan', 8, hour, 13),
          }
        }

        describe 'with day hours' do
          let(:hour) { 14 }

          it 'returns correct day' do
            dates.each_pair do |day, date|
              subject = DayBuilder.new(date).run
              date.wday.must_equal Weesked.availiable_days.index(day.to_s)
              subject.must_be_instance_of Day
              subject.day.must_equal day
              subject.steps.must_equal [ hour ]
            end
          end

        end

        describe 'handles unavailiable times' do
          let(:hour) { 2 }
          it "works" do
            Weesked.availiable_steps = [0,1]
            dates.each_value do |date|
              -> { DayBuilder.new(date).run }.must_raise NotAvailiable
            end
            Weesked.reset
          end
        end
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

        describe 'with night hours' do
          let(:monday_night_range) { Time.local(2020, 'jan', 6, start_at, 12)..Time.local(2020, 'jan', 7, end_at, 34) }
          let(:start_at) { 22 }
          let(:end_at) { 1 }
          subject { DayBuilder.new(monday_night_range).run }
          before do
            Weesked.steps_day_shift = 2
          end
          it 'works for night' do
            subject.day.must_equal :monday
            subject.steps.must_equal [0, 1, 22, 23]
          end
          after do
            Weesked.reset
          end
        end

        describe 'with unavailiable hours' do
          let(:monday_night_range) { Time.local(2020, 'jan', 6, start_at, 12)..Time.local(2020, 'jan', 7, end_at, 34) }
          let(:start_at) { 1 }
          let(:end_at) { 4 }
          subject { DayBuilder.new(monday_night_range).run }
          it 'works for night' do
            -> { subject }.must_raise NotAvailiable
          end
        end

        describe 'with too long range' do
          let(:monday_night_range) { Time.local(2020, 'jan', 6, start_at, 12)..Time.local(2020, 'jan', 10, end_at, 34) }
          let(:start_at) { 22 }
          let(:end_at) { 1 }
          subject { DayBuilder.new(monday_night_range).run }
          it 'works for night' do
            -> { subject }.must_raise NotAvailiable
          end
        end
      end
    end
  end
end