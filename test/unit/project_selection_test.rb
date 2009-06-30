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
  #should_have_readonly_attributes :student_id, :round

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

      context "should act as a list" do
        should "return first" do
          assert_equal @ps.selected_projects[0], @ps.selected_projects.first
        end
        should "return last" do
          assert_equal @ps.selected_projects[4], @ps.selected_projects.last
        end
        should "creates at end" do
          @ps.selected_projects.create(:project => projects(:project6))
          assert_equal 6, @ps.selected_projects.count
          assert_equal projects(:project6), @ps.selected_projects[5].project
          assert_equal @ps, @ps.selected_projects[5].project_selection
          assert_equal 6, @ps.selected_projects[5].position
        end
        should "act like a list" do
          index = 0
          @ps.selected_projects.each do |sp|
            assert_equal @ps.selected_projects[index], sp
            assert_equal (index + 1), sp.position
            index += 1
          end
        end
        should "be able to change position" do
          [5, 4, 3, 2, 1].each_with_index do |pos, i|
            @ps.selected_projects[i].position = pos
            @ps.selected_projects[i].save
          end
          @ps.selected_projects(true) # reload
          assert_equal projects(:project5), @ps.selected_projects[0].project
          assert_equal projects(:project4), @ps.selected_projects[1].project
          assert_equal projects(:project3), @ps.selected_projects[2].project
          assert_equal projects(:project2), @ps.selected_projects[3].project
          assert_equal projects(:project1), @ps.selected_projects[4].project
        end
      end

      context "should return a list of projects" do
        setup do
          @projects = @ps.projects
        end
        should "have all the projects in the selection" do
          assert_equal 5, @projects.size, "should return 5 projects"
        end
        should "be returned in order of preference" do
          pos = 1
          @selected_projects.each_with_index do |selected_project, i|
            assert_equal pos, selected_project.position
            assert_equal selected_project.project, @projects[i]
            pos += 1
          end
        end

        should "maintain order when project dropped" do
          @ps.deselect(projects(:project1))
          sp = @ps.selected_projects
          assert_equal 4, sp.size
          project_ids = [2, 3, 4, 5]
          position = 1
          sp.each_with_index do |selected_project, i|
            assert_equal selected_project.project, Project.find(project_ids[i])
            assert_equal position, selected_project.position
            position += 1
          end
        end
      end
    end
  end
end
