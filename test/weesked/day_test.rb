require File.expand_path("../../test_helper", __FILE__)

module Weesked
  describe Day do

    subject { Day.new day, steps}
    let(:steps) { [18, 19] }
    let(:day) { :monday }

    describe '.steps' do

      describe 'can be initialized with' do
        describe 'single int' do
          let(:steps) { 22 }
          it 'works' do
            subject.steps.must_equal [22]
          end
        end

        describe'single literal' do
          let(:steps) { '22' }
          it 'works' do
            subject.steps.must_equal [22]
          end
        end

        describe'array of ints' do
          let(:steps) { [22, 23] }
          it 'works' do
            subject.steps.must_equal [22, 23]
          end
        end

        describe'array of literals' do
          let(:steps) { ['22', '23'] }
          it 'works' do
            subject.steps.must_equal [22, 23]
          end
        end
      end

      describe 'unavailiable steps' do
        let(:steps) { [22, 23, 24, 25, 26] }
        it 'skips' do
          subject.steps.must_equal [22, 23]
        end
      end

    end

    describe '.day' do

      describe 'can be initialized with' do
        describe 'single int' do
          let(:day) { 1 }
          it 'works' do
            subject.day.must_equal :monday
          end
        end

        describe 'day name as string' do
          let(:day) { 'monday' }
          it 'works' do
            subject.day.must_equal :monday
          end
        end

        describe 'day name as symbol' do
          let(:day) { :monday }
          it 'works' do
            subject.day.must_equal :monday
          end
        end
      end

      describe 'unavailiable day' do
        let(:day) { :monday123 }
        it 'raises' do
          -> { subject }.must_raise WrongDay
        end
      end
    end


  end
end