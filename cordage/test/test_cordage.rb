require File.dirname(__FILE__) + '/helper.rb'

class TestCordage < Test::Unit::TestCase

  def test_basic_construction
    rope = Cordage::Rope.new("test string")
    assert rope.to_s == "test string"
  end

  def test_simple_append
    rope = Cordage::Rope.new("test string")
    rope << " more string"
    assert rope.to_s == "test string more string"
  end

  def test_simple_iteration
    rope = Cordage::Rope.new("test string")
    rope << " more string"
    i = 0
    rope.each do |char|
      i+=1
    end
    assert i == 23
  end

  def test_rope_append
    rope1 = Cordage::Rope.new("test string")
    rope2 = Cordage::Rope.new(" more string")
    rope1 << rope2
    
    assert_equal rope1.to_s, "test string more string"
  end

  def test_append_more
    rope = Cordage::Rope.new("test string")
    rope << " more string"
    rope << " even more string"

    assert_equal rope.to_s, "test string more string even more string"
  end

  def test_rope_depth
    rope = Cordage::Rope.new("test string")
    rope << " more string"

    assert_equal rope.depth, 2
  end

  def test_root_balanced
    rope = Cordage::Rope.new("test string")
    rope << " more string"

    assert_equal rope.root.imbalance, 0
  end

  def test_root_imbalanced
    rope = Cordage::Rope.new("test string")
    rope << " more string"
    rope << " even more string"

    assert_equal 1, rope.root.imbalance
    rope << " even more string"
  end

  def test_root_rebalanced
    rope = Cordage::Rope.new("test string")
    rope << " more string"
    rope << " even more string"

    assert_equal 1, rope.root.imbalance
    rope << " even more string"

    assert_equal 0, rope.root.imbalance
  end

  def test_root_imbalanced_at_9
    rope = Cordage::Rope.new("1")
    puts rope.root.display
    (2..400).each do |i|
      rope << i.to_s
      assert (-1..1).include?(rope.root.imbalance)
    end
  end
end
