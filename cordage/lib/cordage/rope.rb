require 'forwardable'

module Cordage
  CordageError = Class.new(StandardError)
  
  class Rope
    extend Forwardable
    attr_reader :root
    
    def initialize(seed)
      @root = LeafNode.new(seed)
    end

    def << (other)
      case other
        when Rope
          other_node = other.root
        when String
          other_node = LeafNode.new(other)
        when Concatenation
          other_node = other
        else
          raise CordageError.new("Can't append type: #{other.class}")
      end
      @root = Concatenation.new(@root, other_node)
      @root.rebalance
    end

    def_delegators :@root, :to_s, :each, :depth
  end

  class LeafNode
    extend Forwardable
    attr_reader :value

    def initialize(seed)
      @value = seed
    end

    def depth
      1
    end

    def rebalance
    end

    def_delegator :@value, :each_char, :each
    def_delegators :@value, :to_s
  end

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

    def imbalance
      @left.depth - @right.depth
    end

    def rebalance
      imb = imbalance
      until (-1..1).include?(imb) do
        @left.rebalance
        @right.rebalance
        if left_heavy? imb
          if @left.imbalance >= 0
            rotate_right
          else
            @left.rotate_left
            rotate_right
          end
        elsif right_heavy? imb
          if @right.imbalance <= 0
            rotate_left
          else
            @right.rotate_right
            rotate_left
          end
        end
        imb = imbalance
      end
    end

    def left_heavy?(imb)
      imb > 1
    end

    def right_heavy?(imb)
      imb < -1
    end

    def rotate_right
      @right = Concatenation.new(@left.right, @right)
      @left = @left.left
    end

    def rotate_left
      @left = Concatenation.new(@left, @right.left)
      @right = @right.right
    end

  end
end