require File.expand_path("../../test_helper", __FILE__)

class MyClass
  include Weesked::Schedule
  def id
    1
  end
end

module Weesked
  describe Schedule do

    before do
      MyClass.redis = Redis.new
    end

    subject { MyClass.new }

    let(:availiability) {
      MONDAY_SUNDAY_12_14.dup
    }

    let(:availiability_int) {
      availiability.each_with_object(Hash.new) do |k, h|
        h[k.first] = Array(k.last).map(&:to_i).sort.reverse
      end
    }

    it '.redis' do
      MyClass.redis = '123'
      subject.redis.must_equal '123'
    end

    it 'has key' do
      subject.weesked_key(:monday).must_equal 'weesked:myclass:1:monday'
    end

    describe '.schedule=' do

      describe 'with date hash' do

        it 'saves to redis with strings' do
          subject.schedule = availiability
          Redis.current.smembers(subject.weesked_key(:monday)).sort.must_equal [ '12', '13', '14' ]
        end

        it 'saves to redis with empty array' do
          availiability[:monday] = []
          subject.schedule = availiability
          Redis.current.smembers(subject.weesked_key(:monday)).sort.must_equal []
        end

        it 'clears before save' do
          subject.schedule = availiability
          availiability[:monday] = [10]
          subject.schedule = availiability
          Redis.current.smembers(subject.weesked_key(:monday)).sort.must_equal [ '10' ]
        end

        it 'handles empty string' do
          availiability[:monday] = ''
          subject.schedule = availiability
          Redis.current.smembers(subject.weesked_key(:monday)).sort.must_equal []
        end

        it 'saves to redis with ints' do
          subject.schedule = availiability_int
          Redis.current.smembers(subject.weesked_key(:monday)).sort.must_equal [ '12', '13', '14' ]
        end
      end
    end

    describe '.schedule' do

      it 'gets hash' do
        subject.schedule = availiability
        subject.schedule.must_equal availiability_int
      end

    end
  end
end
