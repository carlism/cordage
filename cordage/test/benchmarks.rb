require 'benchmark'
require File.dirname(__FILE__) + '/helper.rb'

Cordage::REBALANCE_AT = 60000
n = 5000
#GC.disable
Benchmark.bm do |x|
  n.times do |nodes|
    x.report("#{nodes}:") do
      str = Cordage::Rope.new("seed ")
      nodes.times do |i|
        str << "appendage #{i}"
      end
    end
  end
end