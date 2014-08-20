require File.expand_path("../../test_helper", __FILE__)

class MyClass
  include Weesked::Schedule
  def id
    1
  end
end

module Weesked
  describe Schedule do

    it '.redis' do
      MyClass.redis = '123'
      obj = MyClass.new
      obj.redis.must_equal '123'
    end
  end
end