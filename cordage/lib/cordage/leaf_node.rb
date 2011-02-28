require 'forwardable'

module Cordage
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
end