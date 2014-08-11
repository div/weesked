require File.expand_path("../../test_helper", __FILE__)

module Weesked
  describe Configuration do
    Configuration::VALID_OPTIONS_KEYS.each do |key|
      describe ".#{key}" do
        it 'returns default value' do
          Weesked.send(key).must_equal Configuration.const_get("DEFAULT_#{key.upcase}")
        end
      end
    end
  end
end