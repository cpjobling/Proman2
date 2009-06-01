#  Copyright 2009 Swansea University.
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  under the License.

require File.dirname(__FILE__) + '/../test_helper'

class TabHelperTest < ActionController::TestCase
  include TabHelper

  fixtures :users, :roles

  Role.find_by_name("staff")
  
  def test_defaults
    assert_equal [:home, :projects, :contact, :about], public_tabs, "Default tabs was not #{[:home, :projects, :contact, :about]}."
  end

  def test_tab_order
    expected = [:home, :admin, :coordinate, :my_account, :projects, :select_projects, :contact, :about]
    assert_equal expected, tab_order, "Tab order was not #{expected}"
  end

  def test_get_tab
    the_tabs = get_tabs do |key, tab|
      expect = the_tabs[key]
      assert_equal expect, get_tab(tab), "Tab should be #{expect}"
    end
  end

  def test_admin_tabs_order
    expect = [:home, :admin, :projects, :contact, :about]
    assert_equal expect, order_tabs([:admin]), "When including :admin tabs should be #{expect}"
  end

  def test_coordinator_tabs_order
    expect = [:home, :coordinate, :projects, :contact, :about]
    assert_equal expect, order_tabs([:coordinate]), "When including :coordinate tabs should be #{expect}"
  end

  def test_account_holder_order
    expect = [:home, :my_account, :projects, :contact, :about]
    assert_equal expect, order_tabs([:my_account]), "When including :my_account tabs should be #{expect}"
  end

  def test_admin_user_tabs
    login_as users(:admin)
    expect = all_tabs
    assert_equal expect, tabs_for_role("admin"), "Admin users should see all tabs"
  end

  def test_all_tabs
    expect = tab_order
    assert_equal expect, all_tabs, "Expected all tabs"
  end

  def test_coordinator_tabs
    expect = [:home, :coordinate, :my_account, :projects, :contact, :about]
    assert_equal expect, tabs_for_role("coordinator"), "Expected coordinator's tabs"
  end

  def test_staff_tabs
    expect = [:home, :my_account, :projects, :contact, :about]
    assert_equal expect, tabs_for_role("staff"), "Expected academic staff's tabs"
  end

  def test_student_tabs
    expect = [:home, :my_account, :projects, :select_projects, :contact, :about]
    assert_equal expect, tabs_for_role("student"), "Expected student's tabs"
  end

  def test_public_tabs
    expect = public_tabs
    assert_equal expect, tabs_for_role(), "Expected public tabs"
  end
end
