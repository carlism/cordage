require_relative 'helper'

class TestCordage < Test::Unit::TestCase

  def setup
    @rope = Cordage::Rope.new("test string")
  end

  def test_basic_construction
    assert @rope.to_s == "test string"
  end

  def test_simple_append
    @rope << " more string"
    assert @rope.to_s == "test string more string"
  end

  def test_simple_iteration
    @rope << " more string"
    i = 0
    @rope.each do |char|
      i+=1
    end
    assert i == 23
  end

  def test_rope_append
    rope2 = Cordage::Rope.new(" more string")
    @rope << rope2
    
    assert_equal @rope.to_s, "test string more string"
  end

  def test_append_more
    @rope << " more string"
    @rope << " even more string"

    assert_equal @rope.to_s, "test string more string even more string"
  end

  def test_rope_depth
    @rope << " more string"

    assert_equal @rope.depth, 2
  end

  def test_rope_size
    @rope << " more string"
    assert_equal 23, @rope.size
    assert_equal 23, @rope.length
  end

  def test_char_at
    @rope << " more string"
    assert_equal "t", @rope[3]
    assert_equal "e", @rope[15]
    assert_equal "s", @rope[17]
  end

  def test_substring
    @rope << " more string"
    assert_equal "t s", @rope[3, 3]
    assert_equal "e st", @rope[15, 4]
    assert_equal "string", @rope[17, 8]
    assert_equal "ng mo", @rope[9, 5]
  end
  
  def test_substring_range
    @rope << " more string"
    assert_equal "t s", @rope[3..6]
    assert_equal "e st", @rope[15, 4]
    assert_equal "string", @rope[17, 8]
    assert_equal "ng mo", @rope[9, 5]
  end

  def test_substring_replace
    @rope << " more string"
    @rope[3..6] = "xyz"
    assert_equal "tesxyztring more string", @rope.to_s
    @rope[9, 5] = "123456789"
    assert_equal "tesxyztri123456789re string", @rope.to_s
  end

  def test_substring_across_middle_nodes
    @rope << " more string"
    @rope << " even more string"
    @rope[9, 17] = "123456789"
    assert_equal "test stri123456789en more string", @rope.to_s
  end

  def test_supports_chained_appends
    @rope << " " << "xyz" << " " << "pdq"
    assert_equal "test string xyz pdq", @rope.to_s
  end

  def test_supports_rebalance_at_100_nodes
    100.times do |x|
      @rope << "node"
    end
    puts @rope.root.depth
    assert @rope.root.depth < 10
    assert_equal 411, @rope.size
  end
end
