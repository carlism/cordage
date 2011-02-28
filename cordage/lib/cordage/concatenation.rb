require 'forwardable'

module Cordage

  class Concatenation
    attr_reader :left, :right

    def initialize(left, right)
      @left, @right = left, right
    end

    def to_s
      @left.to_s + @right.to_s
    end

    def each(&block)
      @left.each(&block)
      @right.each(&block)
    end

    def depth
      [@left.depth, @right.depth].max+1
    end

    def size
      @left.size + @right.size
    end

    def [](first, length=1)
      if first.is_a?(Range)
        first, length = first.first, first.last-first.first
      end
      left_size = @left.size
      if first >= left_size
        @right[first-left_size, length]
      else
        str = @left[first, length]
        if str.size < length
          str << @right[0, length-str.size]
        end
        str
      end
    end

    def []=(first, length=1, new_str)
      if first.is_a?(Range)
        first, length = first.first, first.last-first.first
      end
      left_size = @left.size
      if first >= left_size
        @right[first-left_size, length]=new_str
      else
        str = @left[first, length]
        if str.size < length
          @right[0, length-str.size]=""
        end
        @left[first, length]=new_str
      end
    end

    def collect_leaves
      @left.collect_leaves + @right.collect_leaves
    end

    def insert_at(index, text)
      left_size = @left.size
      side = @left
      if index >= left_size
        side = @right
        index -= left_size
      end
      case side
        when Concatenation
          side.insert_at(index, text)
        when LeafNode
          if side == @left
            @left = Cordage.split_and_insert(side, index, text)
          else
            @right = Cordage.split_and_insert(side, index, text)
          end
      end
    end
  end
end