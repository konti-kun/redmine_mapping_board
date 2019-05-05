require File.expand_path('../../test_helper', __FILE__)

class DummyImage
  attr_accessor :width, :height

  def initialize(**params)
    params.each {|k, v| instance_variable_set("@#{k}", v) }
  end
end

class NoteTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  def test_update_position_1_time
    note = Note.create()
    image = DummyImage.new(width: 10, height:10)
    note.update_position(1,2,image,{"x"=>"0","y"=>"0","width"=>"10","height"=>"10"})
    assert_equal note.x, 1
    assert_equal note.y, 2 
  end

  def test_update_position_half
    note = Note.create()
    image = DummyImage.new(width: 20, height:20)
    note.update_position(2,4,image,{"x"=>"0","y"=>"0","width"=>"10","height"=>"10"})
    assert_equal note.x, 1
    assert_equal note.y, 2 
  end

  def test_update_position_transform
    note = Note.create()
    image = DummyImage.new(width: 20, height:20)
    note.update_position(2,4,image,{"x"=>"5","y"=>"6","width"=>"10","height"=>"10"})
    assert_equal note.x, 1+5
    assert_equal note.y, 2+6 
  end
end
