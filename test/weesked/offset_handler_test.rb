require File.expand_path("../../test_helper", __FILE__)

module Weesked
  describe OffsetHandler do

    let(:input)    { [0, 1, 13, 14, 15, 21, 22, 23] }
    let(:input2)   { [1, 2, 3, 13, 14, 15, 21, 22, 23] }
    let(:input3)   { [1, 2, 10, 11, 12, 17, 19, 21, 23] }
    let(:offset)   { 2 }
    let(:offset2)  { 4 }
    let(:offset3)  { 4 }

    describe '#offset' do
      let(:output)  { [13, 14, 15, 21, 22, 23, 0, 1] }
      let(:output2) { [13, 14, 15, 21, 22, 23, 1, 2, 3] }
      let(:output3) { [10, 11, 12, 17, 19, 21, 23, 1, 2] }
      subject { OffsetHandler.new(input, offset).to_a }
      it 'returns same array if input empty or offset in zero' do
        OffsetHandler.new.to_a.must_equal []
        OffsetHandler.new(input).to_a.must_equal input
      end
      it 'returns array with offset' do
        subject.must_equal output
      end
      it 'returns array with offset' do
        OffsetHandler.new(input2, offset2).to_a.must_equal output2
      end
      it 'returns array with offset' do
        OffsetHandler.new(input3, offset3).to_a.must_equal output3
      end
    end

    describe '#to_range' do
      let(:output)  { [13..15, 21..1] }
      let(:output2)  { [13..15, 21..23, 1..3] }
      let(:output3)  { [10..12, 17..17, 19..19, 21..21, 23..23, 1..2] }
      subject { OffsetHandler.new(input, offset).to_range }
      it 'returns array with ranges' do
        subject.must_equal output
      end
      it 'returns array with ranges' do
        (OffsetHandler.new(input2, offset2).to_range).must_equal output2
      end
      it 'returns array with ranges' do
        (OffsetHandler.new(input3, offset3).to_range).must_equal output3
      end
    end
  end
end