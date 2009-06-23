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

class StatusTest < ActiveSupport::TestCase
  should_belong_to :status_setting

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
      assert_equal @setting.code,         @status.code
      assert_equal @setting.title,        @status.title
      assert_equal @setting.message,      @status.message
      assert_equal @setting.permissions,  @status.permissions
      assert_equal @setting.default_permissions, @status.default_permissions
      assert_equal @setting.octal_permissions, @status.octal_permissions
      assert_equal @setting.can_select?,   @status.can_select?
      assert_equal @setting.can_allocate?, @status.can_allocate?
      assert_equal @setting.selection_round, @status.selection_round
    end
  end
end
