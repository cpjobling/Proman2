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


class RoleTest < ActiveSupport::TestCase

  should_have_and_belong_to_many :users
  should_validate_presence_of    :name
  should_validate_uniqueness_of  :name
  
  # Replace this with your real tests.
  def test_admin_role_exists
    admin_role = Role.find_by_name('admin')
    assert_not_nil admin_role, "There needs to be an admin role" 
  end
  
  def test_key_roles_exist
  	['student', 'staff', 'coordinator'].each do |role|
  		assert_not_nil role, "Role #{role} is needed for this application to work"
  	end
  end

  test "Roles from static cache" do
    Role::ROLES.each_with_index do |role, i|
      db_role = Role.find(role[i][1]) # id
      assert_equal role[i][0]. db_role.name,   "Cached role-name wasn't #{role[i][0]}"
      assert_equal role[i][1], db_role.id,     "Cached role id wasn't #{role[i][1]}"
    end
  end
end
