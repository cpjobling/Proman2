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

class StudentTest < ActiveSupport::TestCase

  fixtures :students, :project_selections, :selected_projects

  should_belong_to :user, :discipline
  should_have_one :project_selection, :dependent => :destroy
  should_have_one :project_allocation, :dependent => :destroy

  #  id            :integer         not null, primary key
  #  user_id       :integer
  #  grade         :decimal(, )
  #  discipline_id :integer
  #  student_id    :string(255)
  #  created_at    :datetime
  #  updated_at    :datetime

  should_validate_presence_of :user_id, :discipline_id, :student_id, :grade
  should_ensure_length_in_range :student_id, (6..10)
  should_validate_numericality_of :student_id
  should_validate_uniqueness_of :student_id
  should_validate_numericality_of :grade

  context "a student" do
    setup do
      @student = students(:student1)
    end

    should "only accept a grade that is between 0 and 100" do
      for grade in 0..100
        @student.grade = grade
        assert_valid(@student)
      end
    end

    should "not except a negative grade" do
      @student.grade = -0.999999999999999999999999999999999999999999999999999999
      assert ! @student.valid?
    end

    should "not accept a grade that is just a bit more than 100.00" do
      @student.grade = 100.00
      assert_valid @student
      @student.grade = 100.01
      assert ! @student.valid?
    end

  end

  context "a student with a project selection" do
    setup do
      @student = students(:student2)
    end

    should "have a project selection" do
      assert_not_nil @student.project_selection
    end

    context "deselection of a project" do
      setup do
        @project = projects(:project3)
      end

      should "have project in selection" do
        assert @student.project_selection.selected_projects.find_by_project_id(@project)
      end

      should "be able to remove project from selection" do
        @student.deselect(@project)
        assert_nil @student.project_selection.selected_projects.find_by_project_id(@project)
      end

      should "allocate project from the student's selection" do
        assert_equal 5, @student.project_selection.selected_projects.count
        @student.allocate(@project)
        assert_nil @student.project_selection
        pa = ProjectAllocation.find_by_project_id(@project.id)
        assert_equal @project.id, pa.project_id
        assert_equal @student.id, pa.student_id
        assert_equal @project.supervisor.id, pa.supervisor_id
        assert ! @project.available?, "should not be available"
        assert_equal 1, pa.allocation_round, "should have been allocated in round 1"
      end

      should "not allocate project that isn't in the student's selection" do
        before = @student.project_selection.selected_projects.count
        @student.allocate(projects(:project6))
        assert_equal 5, before
      end

    end

    should "destroy project selection" do
      @student.drop_selection
      assert_nil @student.project_selection
    end

    should "return projects in selection" do
      selection = @student.selection
      assert @student.project_selection.selected_projects.count, selection.size
      @student.project_selection.selected_projects.each_with_index do |ps, i|
        assert_equal ps.project, selection[i], "ps.project should be equal to selection[#{i}]"
      end
    end
  end


  def setup
    @student = students(:student1)
    @user = users(:student1)
    @icct = disciplines(:icct)
  end
  # Replace this with your real tests.
  test "student has a user" do
    assert_equal @user, @student.user, "Student 1 wasn't owned by user student1"
  end

  test "student fields" do
    #student1:
    #  id: 1
    #    user_id: 201
    #    student_id: 382392
    #    discipline_id: 1
    #    grade: 99.9
    assert_equal @user.id, @student.user_id
    assert_equal '382392', @student.student_id
    assert_equal @icct, @student.discipline
    assert @student.grade > 99.0
  end

  test "delegated user methods" do
    assert_equal @user.email, @student.email
    assert_equal @user.name.to_s, @student.name.to_s
  end

  test "chained access methods still work" do
    assert_equal @icct.name, @student.discipline.name
    assert_equal @icct.long_name, @student.discipline.long_name
  end

  test "delegated discipline methods" do
    assert_equal @icct.name, @student.disc_name
    assert_equal @icct.long_name, @student.disc_long_name
  end

  test "can have a board decision" do
    decision = "Progress:CL"
    @student.board_decision = decision
    @student.save
    assert_equal decision, @student.board_decision
  end
end
