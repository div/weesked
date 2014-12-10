module Weesked
  class OffsetHandler

    def initialize(ary = [], offset = 0, length = 24)
      @ary = ary.sort
      @offset = offset
      @length = length
    end

    def to_a
      return ary if ary.length == 0 || offset == 0
      ary.push(ary.shift(offset)).flatten
    end

    def to_range
      to_a.inject([]) do |spans, n|
        if start_new_range? spans, n
          spans + [n..n]
        else
          spans[0..-2] + [spans.last.first..n]
        end
      end
    end

    private

      attr_reader :ary, :offset, :length

      def start_new_range? spans, current
        return true if spans.empty?
        previous = spans.last.last
        return true unless consecutive?(previous, current) || consecutive_with_offset?(previous, current)
      end

      def max? n
        n == max
      end

      def max
        length - 1
      end

      def consecutive_with_offset? x, y
        x % max == y && max?(x)
      end

      def consecutive? x, y
        x == y - 1
      end

  end

end