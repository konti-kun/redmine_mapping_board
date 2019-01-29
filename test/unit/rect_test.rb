require File.expand_path('../../test_helper', __FILE__)

class RectTest < ActiveSupport::TestCase
  
  test "rect init" do
    obj = Rect.new(0,1,2,3)
    assert_equal 0, obj.x
    assert_equal 1, obj.y
    assert_equal 2, obj.width
    assert_equal 3, obj.height
  end

  test "rect init by json" do
    obj = Rect.new('{"x":0,"y":1,"width":2,"height":3}')
    assert_equal 0, obj.x
    assert_equal 1, obj.y
    assert_equal 2, obj.width
    assert_equal 3, obj.height
  end
end
