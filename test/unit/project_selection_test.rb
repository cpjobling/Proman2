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

class ProjectSelectionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_have_many :selected_projects, :dependent => :delete_all
  should_belong_to :student

  should_validate_presence_of :student_id, :round
  should_validate_numericality_of :student_id, :round
  should_have_readonly_attributes :student_id, :round

  # new one should have round set

  context "a new project selection" do
    setup do
      @student = students(:student5)
      @ps = ProjectSelection.new(:student => @student, :round => 0)
    end

    should "have student" do
      assert_equal @student, @ps.student
      assert_equal 0, @ps.round
    end

    context "made in a selection round" do
      setup do
        @status = Status.find(1)
        @status.status_setting = StatusSetting.find(5)
      end

      should "be made in round 1" do
        ps = ProjectSelection.new(:student => @student, :round => @status.selection_round)
        assert_equal 1, ps.round
        assert_valid ps
      end
    end
  end

  context "a project selection" do
    setup do
      @student = students(:student1)
      @ps = @student.project_selection
    end

    should "have student" do
      assert_equal @student, @ps.student
      assert_equal 1, @ps.round
    end

    context "should have some selected projects" do

      setup do
        @selected_projects = @ps.selected_projects
      end

      should "should have 5 selected projects" do
        assert_equal 5, @selected_projects.count
      end

      should "deselect a project" do
        project = projects(:project1)
        @ps.deselect(project)
        assert_equal 4, @selected_projects.count
      end
    end
  end
  # should be an ordered list


end
