#  Copyright 2009-2010 Swansea University.
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
require 'mocha'

class TabHelperTest < ActionController::TestCase
  include TabHelper

  fixtures :users, :roles

  def setup
    @staff = Role.find_by_name("staff")
  end

  context "default status" do
    setup do
      set_status(status_settings("pre-registration"))
    end

    should "have default tabs" do
      assert_equal [:home, :projects, :news_items, :contact, :about], public_tabs, "Default tabs was not #{[:home, :projects, :news_items, :contact, :about]}."
    end

    should "have correct tab order" do
      expected = [:home, :my_account, :admin, :coordinate, :projects, :project_allocations, :project_selections, :news_items, :contact, :about]
      assert_equal expected, tab_order, "Tab order was not #{expected}"
    end

    should "get_tab" do
      the_tabs = get_tabs do |key, tab|
        expect = the_tabs[key]
        assert_equal expect, get_tab(tab), "Tab should be #{expect}"
      end
    end

    should "have admintabs" do
      expect = [:home, :admin, :projects, :news_items, :contact, :about]
      assert_equal expect, order_tabs([:admin]), "When including :admin tabs should be #{expect}"
    end

    should "have coordinator tabs" do
      expect = [:home, :coordinate, :projects, :news_items, :contact, :about]
      assert_equal expect, order_tabs([:coordinate]), "When including :coordinate tabs should be #{expect}"
    end


    should "have my_account tabs order" do
      expect = [:home, :my_account, :projects, :news_items, :contact, :about]
      assert_equal expect, order_tabs([:my_account]), "When including :my_account tabs should be #{expect}"
    end

    should "have admin user tabs" do
      login_as users(:admin)
      expect = all_tabs
      assert_equal expect, tabs_for_role("admin"), "Admin users should see all tabs"
    end

    should "return all tabs" do
      expect = tab_order
      assert_equal expect, all_tabs, "Expected all tabs"
    end

    should "return coordinator tabs" do
      expect = [:home, :my_account, :coordinate, :projects, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("coordinator"), "Expected coordinator's tabs"
    end

    should "return staff tabs" do
      expect = [:home, :my_account, :projects, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("staff"), "Expected academic staff's tabs"
    end

    should "return student tabs" do
      expect = [:home, :my_account, :projects, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("student"), "Expected student's tabs"
    end

    should "return public tabs" do
      expect = public_tabs
      assert_equal expect, tabs_for_role(), "Expected public tabs"
    end
  end

  context "can't select projects" do
    setup do
      set_status(status_settings(:allocation1))
    end

    should "not have select projects tab" do
      expect = [:home, :my_account, :projects, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("student"), "Expected student's tabs"
    end
  end

  context "can't allocate projects" do
    setup do
      set_status(status_settings(:selection1))
    end

    should "not have allocate projects tab" do
      expect = [:home, :my_account, :coordinate, :projects, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("coordinator"), "Expected coordinator's tabs"
    end
  end

  context "when project selection is live, students" do
    setup do
      login_as users(:student1)
      set_status(status_settings(:selection1))
    end

    should "see project_selections tabs" do
      expect = [:home, :my_account, :projects, :news_items, :project_selections, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("student"), "Expected student's tabs"
    end
  end

  context "when project allocation is live" do
    setup do
      login_as users(:coordinator)
      set_status(status_settings(:allocation1))
    end
    should "see project_allocations tabs" do
      expect = [:home, :my_account, :coordinate, :projects, :project_allocations, :news_items, :contact, :about]
      assert_equal expect, tabs_for_role("coordinator"), "Expected coordinator's tabs"
    end

  end

  private

  def set_status(setting)
    status = Status.find(1)
    status.status_setting = setting
    status.save
  end
end
