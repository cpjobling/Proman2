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

class UserTypesTest < ActiveSupport::TestCase

  def setup
    @staff =         users(:academic)
    @coordinator =   users(:coordinator)
    @student =       users(:student1)
    @administrator = users(:admin)
  end

  test "Staff" do
    assert_equal '544543', @staff.staff_number
    assert_equal 4, @staff.loading
    assert_equal research_centres(:mrc), @staff.research_centre
    assert @staff.has_role?('staff')
    assert_equal Supervisor, @staff.class
  end

  test "Student" do
    assert_equal '382392', @student.student_number
    assert_equal 99.9, @student.grade
    assert_equal disciplines(:icct), @student.discipline
    assert @student.has_role?('student')
    assert_equal Student, @student.class
  end

  test "Coordinator" do
    assert_equal '667543', @coordinator.staff_number
    assert_equal 4, @coordinator.loading
    assert_equal research_centres(:c2ec), @coordinator.research_centre
    assert @coordinator.has_role?('coordinator')
    assert @coordinator.has_role?('staff')
    assert_equal Supervisor, @coordinator.class
  end

  test "Admin" do
    assert_nil @administrator.staff_number
    assert_equal 4, @administrator.loading
    assert_nil @administrator.student_number
    assert_nil @administrator.grade
    assert @administrator.has_role?('admin')
    assert_equal User, @administrator.class
  end
end
