require File.expand_path("../../test_helper", __FILE__)

class Myclass
  attr_accessor :id
  include Weesked::Schedule
  include Weesked::Availiability
  def initialize(id) @id=id; end
end

module Weesked
  describe Availiability do

    let(:sitter1) { Myclass.new 13}
    let(:sitter2) { Myclass.new 18}

    let(:s1) {
      MONDAY_TUESDAY_12_14.dup
    }

    let(:s2) {
      TUESDAY_12_14.dup
    }

    let(:empty) {
      EMPTY_AVAIL.dup
    }

    subject { Myclass.availiability(date_range) }
    let(:start_at) { 11 }
    let(:end_at) { 15 }
    let(:monday_range) { Time.local(2020, 'jan', 6, start_at)..Time.local(2020, 'jan', 6, end_at, 34) }
    let(:tuesday_range) { Time.local(2020, 'jan', 7, start_at)..Time.local(2020, 'jan', 7, end_at, 34) }
    let(:date_range) { monday_range }

    before do
      Myclass.reset_schedule
      sitter1.schedule = s1
      sitter2.schedule = s2
    end

    describe '.availibility' do

      describe 'single sitter' do

        describe 'no intersection' do
          let(:start_at) { 15 }
          let(:end_at) { 18 }
          it 'empty array' do
            subject.must_equal Set.new
          end
        end

        describe 'partial intersection' do
          let(:start_at) { 14 }
          let(:end_at) { 15 }
          it 'empty array' do
            subject.must_equal Set.new
          end
        end

        describe 'date_range broader than availibility' do
          let(:start_at) { 10 }
          let(:end_at) { 22 }
          it 'empty array' do
            subject.must_equal Set.new
          end
        end

        describe 'exact intersection' do
          let(:start_at) { 12 }
          let(:end_at) { 14 }
          it 'sitter id' do
            subject.must_equal [ sitter1.id.to_s ]
          end
        end

        describe 'date_range narrower than availibility' do
          let(:start_at) { 12 }
          let(:end_at) { 13 }
          it 'sitter id' do
            subject.must_equal [ sitter1.id.to_s ]
          end
        end

      end

      describe 'multiple sitters' do

        let(:date_range) { tuesday_range }

        describe 'no intersection' do
          let(:start_at) { 15 }
          let(:end_at) { 18 }
          it 'empty array' do
            subject.must_equal Set.new
          end
        end

        describe 'partial intersection' do
          let(:start_at) { 14 }
          let(:end_at) { 15 }
          it 'empty array' do
            subject.must_equal Set.new
          end
        end

        describe 'date_range broader than availibility' do
          let(:start_at) { 10 }
          let(:end_at) { 22 }
          it 'empty array' do
            subject.must_equal Set.new
          end
        end

        describe 'exact intersection' do
          let(:start_at) { 12 }
          let(:end_at) { 14 }
          it 'sitter id' do
            subject.must_equal [ sitter1.id.to_s, sitter2.id.to_s ]
          end
        end

        describe 'date_range narrower than availibility' do
          let(:start_at) { 12 }
          let(:end_at) { 13 }
          it 'sitter id' do
            subject.must_equal [ sitter1.id.to_s, sitter2.id.to_s ]
          end
        end

      end

      describe '.availiable?' do
        subject { sitter1.availiable?(date_range) }

        describe 'for availiable' do
          let(:start_at) { 12 }
          let(:end_at) { 13 }
          it 'true' do
            subject.must_equal true
          end
        end

        describe 'for unavailiable' do
          let(:start_at) { 18 }
          let(:end_at) { 19 }
          it 'false' do
            subject.must_equal false
          end
        end
      end

    end
  end
end
