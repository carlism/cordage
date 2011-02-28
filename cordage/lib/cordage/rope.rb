require 'forwardable'

module Cordage
  CordageError = Class.new(StandardError)
  REBALANCE_AT = 100

  class Rope
    extend Forwardable
    attr_reader :root

    def initialize(seed)
      @root = LeafNode.new(seed)
      @nodes = 1
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
      @nodes += 1
      if @nodes % REBALANCE_AT == 0
        rebalance
      end
      self
    end

    def rebalance
      @root = rebuild(leaves)
    end

    def leaves
      @root.collect_leaves
    end

    def rebuild(nodes)
      size = nodes.size
      case size
        when 1
          nodes.first
        when 2
          Concatenation.new(nodes.first, nodes.last)
        else
          m = size/2
          Concatenation.new(rebuild(nodes[0...m]), rebuild(nodes[m..size]))
      end
    end

    def_delegator :@root, :size, :length
    def_delegators :@root, :to_s, :each, :depth, :size, :[], :[]=

    private
    
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

    def collect_leaves
      [self]
    end
    
    def_delegator :@value, :each_char, :each
    def_delegators :@value, :to_s, :size, :char_at, :[], :[]=
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
  end
end