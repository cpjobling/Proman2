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

class SupervisorTest < ActiveSupport::TestCase

  fixtures :users
  
  should_validate_presence_of :staff_number, :research_centre_id
  should_validate_uniqueness_of :staff_number
  should_ensure_length_in_range :staff_number, (6..8)
  should_validate_numericality_of :staff_number

  should_have_many :projects, :dependent => :destroy
  should_belong_to :research_centre

  # delegations
  context "given a supervisor record" do
    setup do
      @supervisor = users(:cpj)
    end

    should "have same name as associated user" do
      assert_equal "Dr Christopher P. Jobling", @supervisor.name.to_s
    end

    should "have same email as associated user" do
      assert_equal "C.P.Jobling@Swansea.ac.uk".downcase, @supervisor.email
    end

    should "have the correct research centre, rc abbreviation and rc title" do
      assert_equal "mnc", @supervisor.rc_abbrev
      assert_equal "Multidisciplinary Nanotechnology Centre", @supervisor.rc_title
      assert_equal research_centres(:mnc), @supervisor.research_centre
    end

    should "have right number of projects" do
      expected_number = 4
      assert_not_nil @supervisor.projects, "Should not be nil"
      assert ! @supervisor.projects.blank?, "Should have some projects"
      assert_equal expected_number, @supervisor.projects.count, "Should have #{expected_number} projects"
    end
  end
end
