require File.dirname(__FILE__) + '/../test_helper'

require File.dirname(__FILE__) + '/../../app/models/user'

class NameTest < Test::Unit::TestCase

  def setup
    @my_name = Name.new("Dr", "Christopher", "P.", "Jobling", "Chris")
  end

  def test_can_access_all_parts_of_a_name
    assert_equal "Dr", @my_name.title, "can't access name.title"
    assert_equal "Christopher", @my_name.first, "can't access name.first"
    assert_equal "Jobling", @my_name.last, "can't access name.last"
    assert_equal "Chris", @my_name.known_as, "can't access name.known_as"
  end

  def test_to_s_works_as_advertised
    expected = "Dr Christopher P. Jobling"
    assert_equal expected, @my_name.to_s, "name.to_s isn't #{expected} as expected"
  end

  def test_formal_address
    expected = "Dr Jobling"
    assert_equal expected, @my_name.formally, "name.formally isn't #{expected} as expected"
  end

  def test_my_informal_name
    expected = "Chris"
    assert_equal expected, @my_name.informally, "name.informally isn't #{expected} as expected"
  end

    def test_should_default_to_first_name_when_no_informal_name_given
    javier = Name.new("Prof", "Javier", "", "Bonet") # No known_as field
    expected = "Javier"
    assert_equal expected, javier.informally, "name.informally isn't #{expected} as expected"
  end

end