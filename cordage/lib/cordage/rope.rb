require 'forwardable'
require_relative 'leaf_node'
require_relative 'concatenation'

module Cordage
  extend self
  CordageError = Class.new(StandardError)
  REBALANCE_AT = 100

  def split_and_insert(leaf, index, text)
    if index == 0
      Concatenation.new(LeafNode.new(text), leaf)
    elsif index == leaf.size
      Concatenation.new(leaf, LeafNode.new(text))
    else
      left = LeafNode.new(leaf.value[0...index])
      right = LeafNode.new(leaf.value[index..leaf.size])
      middle = LeafNode.new(text)
      Concatenation.new(left, Concatenation.new(middle, right))
    end
  end

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
      @root = rebuild(@root.collect_leaves)
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

    def insert_at(index, text)
      case @root
        when Concatenation
          @root.insert_at(index, text)
        when LeafNode
          @root = Cordage.split_and_insert(@root, index, text)
      end
    end

    def_delegator :@root, :size, :length
    def_delegators :@root, :to_s, :each, :depth, :size, :[], :[]=
  end
end