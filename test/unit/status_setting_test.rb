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

require 'test_helper'

class StatusSettingTest < ActiveSupport::TestCase

  should_have_one :status
  should_validate_presence_of :code, :message, :title, :selection_round, :permissions
  should_validate_uniqueness_of :code
  should_validate_numericality_of :code, :selection_round, :permissions

  context "default status setting" do
    setup do
      @status = statuses(:status)
      @setting = status_settings(:offline)
      @status.status_setting = @setting
    end

    should "be default status" do
      assert_equal @setting, @status.status_setting
    end

    should "delegate code, title, message, permissions, can_select and can_allocate to status_setting" do
      # id: 1
      #   code: 100
      #   title: System offline
      #   message: The system is offline for maintainance. Please check back later.
      #   permissions: 070000
      assert_equal 100, @setting.code
      assert_equal 'System offline', @setting.title
      assert_equal 'The system is offline for maintainance. Please check back later.',
        @setting.message
      assert_equal 070000, @setting.permissions
      assert_equal false, @setting.can_select
      assert_equal false, @setting.can_allocate
      assert_equal 0, @setting.selection_round
    end
  end

  context "new status setting" do
    setup do
      @setting = StatusSetting.new(:code => 900, :title => 'test', :message => 'test', :permissions => 070000)
    end

    should "be able to set selection_round" do
      assert_equal 0,  @setting.selection_round, "Default selection round should be 0"
      round = 10
      @setting.selection_round = round
      assert_equal round, @setting.selection_round, "Couldn't change selection round"
    end

    should "be able to set can_allocate" do
      assert ! @setting.can_allocate, "Default should be false"
      @setting.can_allocate = true
      assert @setting.can_allocate, "Can be set to true"
      @setting.can_allocate = false
      assert ! @setting.can_allocate, "Can be set to false"
    end

    should "be able to set can_select" do
      assert ! @setting.can_select, "Default should be false"
      @setting.can_select = true
      assert @setting.can_select, "Can be set to true"
      @setting.can_select = false
      assert ! @setting.can_allocate, "Can be set to false"
    end
  end

  context "a new status setting with permissions set as octal" do
    setup do
      @setting = StatusSetting.new(:code => 5123, :title => "test", :message => "test", :octal_permissions => '76543')
    end

    should "set permissions" do
      assert_equal 076543, @setting.permissions
    end

    should "return permissions as an octal string" do
      assert_equal '76543', @setting.octal_permissions
    end
  end

  context "a new status setting with permissions set as decimal" do
    setup do
      @setting = StatusSetting.new(:code => 5123, :title => "test", :message => "test", :permissions => 076543)
    end

    should "set permissions" do
      assert_equal 076543, @setting.permissions
    end

    should "return permissions as an octal string" do
      assert_equal '76543', @setting.octal_permissions
    end
  end
end
