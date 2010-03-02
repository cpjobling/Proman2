# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


require File.dirname(__FILE__) + '/../test_helper'

require File.dirname(__FILE__) + '/../../app/models/user'

class NameTest < Test::Unit::TestCase

  def setup
    @my_name = Name.new("Dr", "Christopher", "Jobling", "P.", "Chris")
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
    javier = Name.new("Prof.", "Javier", "Bonet") # No known_as field
    expected = "Javier"
    assert_equal expected, javier.informally, "name.informally isn't #{expected} as expected"
  end

end