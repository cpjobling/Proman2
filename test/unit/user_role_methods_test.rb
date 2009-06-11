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


class UserRoleMethodsTest < ActiveSupport::TestCase

  fixtures :users

  test "Admin user is administrator" do
    assert users(:admin).administrator?, 'Admin user is not administrator!'
  end

  test "Other users are not administrators" do
    assert ! users(:academic).administrator?, 'Staff user should not be an administrator!'
    assert ! users(:student1).administrator?, 'Student user should not be an administrator!'
    assert ! users(:coordinator).administrator?, 'Coordinator user should not be an administrator!'
  end

  test "Coordinator is a coordinator" do
    assert users(:coordinator).coordinator?, 'Coordinator user is not a coordinator!'
  end

  test "Admin user is a coordinator" do
    assert users(:admin).coordinator?, 'Admin user is not a coordinator!'
  end

  test "Staff and students are not coordinators" do
    assert ! users(:academic).coordinator?, 'Staff user should not be a coordinator!'
    assert ! users(:student1).coordinator?, 'Student user should not be a coordinator!'
  end

  test "Staff user is a supervisor" do
    assert users(:academic).supervisor?, 'Staff user is a supervisor!'
  end

  test "Coordinator user is a supervisor" do
    assert users(:coordinator).supervisor?, 'Coordinator user is a supervisor!'
  end

  test "Admin user is a supervisor" do
    assert users(:admin).supervisor?, 'Admin user is a supervisor!'
  end

  test "Students are not supervisors" do
    assert ! users(:student1).supervisor?, 'Student user should not be a supervisor!'
  end

  test "Student user is a student" do
    assert users(:student1).student?, 'Student user is a student'
  end

  test "Admin user is a student" do
    assert users(:admin).student?, 'Admin user is a student'
  end

  test "Coordinator/staff users are not students" do
    assert ! users(:coordinator).student?, 'Coordinator user is a student!'
    assert ! users(:academic).student?, 'Staff user is a student!'
  end

end
