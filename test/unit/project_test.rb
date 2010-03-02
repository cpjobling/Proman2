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

class ProjectTest < ActiveSupport::TestCase

  fixtures :users, :projects

  def setup
    @project = projects(:test)
    @disciplines = Discipline.find(:all)
    @icct = disciplines(:icct)
  end

  should_have_and_belong_to_many :disciplines
  should_belong_to :user
  should_have_many :selected_projects, :dependent => :delete_all
  should_have_one :project_allocation, :dependent => :destroy

  should_validate_presence_of :title, :description, :created_by
  should_validate_uniqueness_of :title


  # Replace this with your real tests.
  def test_truth
    assert true
  end

  # Test validation rules
  def test_invalid_with_empty_atributes
  	project = Project.new
  	assert !project.valid?
  	assert project.errors.invalid?(:title)
  	assert project.errors.invalid?(:description)
  	assert project.errors.invalid?(:created_by)
  end

  def test_unique_title
  	project = Project.new(:title => projects(:project1).title,
  		:description => "A dummy project",
  		:created_by => users(:academic).id)

  	assert !project.save
  	assert_equal "has already been taken", project.errors.on(:title)
  end

  def test_project_creator_is_valid
    users = User.find(:all)
    users.each do |user|
      if user.has_role?('staff')
        projects = Project.find(:all,
          :conditions => ["created_by = ?", user.id])
        projects.each do |project|
          assert_equal project.created_by, user.id,
            "user #{user.id} didn't create project #{project.id}"
        end
      end
    end
  end

  def test_project_can_be_carbon_critical
  	assert !@project.carbon_critical,
  		"project by default should not be carbon critical"
  	@project.carbon_critical = true
  	assert @project.carbon_critical,
  		"project by should now be carbon critical"
  end

  def test_project_not_assigned_to_discipline
  	@disciplines.each do |discipline|
  		assert !@project.suitable_for?(discipline.name)
  	end
  end

  test "we can add a discipline by name" do
    discipline = @icct
    assert ! @project.suitable_for?(@icct.name), "Before: should be not suitable for @icct.name"
    @project.suitable_for(discipline.name)
    assert @project.suitable_for?(@icct.name), "After should now be suitable for @icct.name"
  end

  test "we can add a discipline by id" do
    discipline = @icct
    assert ! @project.suitable_for?(@icct.id), "Before: should be not suitable for @icct.id"
    @project.suitable_for(discipline.id)
    assert @project.suitable_for?(@icct.id), "After should now be suitable for @icct.id"
  end

  test "we can add a discipline by object" do
    discipline = @icct
    assert ! @project.suitable_for?(@icct), "Before: should be not suitable for @icct"
    @project.suitable_for(discipline)
    assert @project.suitable_for?(@icct), "After should now be suitable for @icct"
  end

  test "test that we can recognize a discipline by name" do
  	discipline = @icct
  	@project.disciplines << discipline
  	assert @project.suitable_for?(discipline.name)
  end

  test "test that we can recognize a discipline by object" do
    discipline = @icct
    @project.disciplines << discipline
    assert @project.suitable_for?(discipline)
  end

  test "test that we can recognize a discipline by object id" do
    discipline = @icct
    @project.disciplines << discipline
    assert @project.suitable_for?(discipline.id)
  end

  test "test that we can't recognize a discipline by arbitrary type" do
    discipline = @icct
    @project.disciplines << discipline
    assert ! @project.suitable_for?(users(:admin))
  end

  def test_project_suitable_for_all
  	@disciplines.each do |discipline|
  		@project.disciplines << discipline
  	end
    assert @project.suitable_for_all?,
      "Project should suit all disciplines"
  end

  def test_unnassigned_project_not_suitable_for_all
    assert ! @project.suitable_for_all?,
      "Unaasigned project should not suit all disciplines"
  end

  def test_singly_assigned_project_not_suitable_for_all
  	@project.disciplines << @icct
    assert ! @project.suitable_for_all?,
      "Project assigned to one discipline should not suit all disciplines"
  end

  def test_project_assigned_to_all_but_one_discipline_not_suitable_for_all
  	@disciplines.each do |discipline|
  		@project.disciplines << discipline
  	end

  	# Remove last discipline
  	@project.disciplines.delete(disciplines(:sports_materials))
    assert ! @project.suitable_for_all?,
      "Project assigned to all but one discipline should not suit all disciplines"
  end

  def test_suitable_for_any
  	assert ! @project.suitable_for_any?, "Project should not be suitable for any"
  	@project.disciplines << @icct
  	assert @project.suitable_for_any?, "Project should be suitable for any"
  end

  def test_suitable_for_discipline
  	assert ! @project.suitable_for_any?,
      "Project should not be suitable for any discipine"
  	discipline = @icct
  	@project.suitable_for(discipline.name)
  	assert @project.suitable_for?(discipline.name),
      "project should now be suitable for #{discipline.name}"
  end

  def test_cant_add_unknown_discipline_to_project
  	@project.suitable_for('cheesemakers')
  	assert @project.disciplines.count(:all) == 0,
  	  "There should be no cheesemakers"
  end

  def test_cant_add_duplicate_discipline_to_project
  	@project.suitable_for(@icct.name)
  	assert @project.disciplines.count(:all) == 1,
  	  "Should be 1 suitable discipline for project"
  	@project.suitable_for(@icct.name)
  	assert @project.disciplines.count(:all) == 1,
  	  "Should still be 1 suitable discipline for project"
  	@project.suitable_for(disciplines(:eee).name)
  	assert @project.disciplines.count(:all) == 2,
  	  "Should now be 2 suitable discipline for project"
  end

  def test_suitable_for_all
  	@project.suitable_for_all
  	assert @project.suitable_for_all?, "Project is suitable for all"
  end

  def test_discipline_suitable_for_none
  	@project.suitable_for_all
  	@project.suitable_for_none
  	assert ! @project.suitable_for_all?, "Project is suitable for all"
  	assert ! @project.suitable_for_any?, "Project is not suitable for any"
  end

  def test_discipline_suitable_for_none?
  	@project.suitable_for_all
  	@project.suitable_for_none
  	assert @project.suitable_for_none?, "Project is suitable for none"
  end

  context "availability of a project" do
    setup do
      @project = projects(:project1)
    end

    should "honour availability flag" do
      assert @project.available?, "project 1 should be available"
      @project.available = false
      assert ! @project.available?, "project 1 should not be available"
    end

    context "supervisor" do
      setup do
        @supervisor = @project.supervisor
      end

      should "be the correct supervisor" do
        assert_equal supervisors(:staff), @supervisor
      end

      should "have the default loading" do
        assert_equal 4, @supervisor.loading
      end

      should "not be available if staff loading is exceeded" do
        @supervisor.load = 3
        assert @project.available?, "should be available"
        @supervisor.load += 1
        assert ! @project.available?, "should not now be available"
      end
    end

    context "after allocation to a student" do
      setup do
        @student = students(:student1)
      end

      should "not be available" do
        @project.allocate(@student, 1)
        assert ! @project.available?
      end

      should "be allocated" do
        assert ! @project.allocated?
        @project.allocate(@student, 1)
        assert @project.allocated?
      end
    end
  end

  context "allocating a project" do
    setup do
      @project = projects(:project3)
    end

    should "be available" do
      assert @project.available?, "project1 should be available"
    end

    context "with a student" do
      setup do
        @student = students(:student1)
      end
    
      should "be a valid student" do
        assert_not_nil @student, "there should be a student 1"
      end
      
      should "have a valid project selection" do
        assert_not_nil @student.project_selection, "student 1 has a project selection"
      end
      should "be 10 selected projects in total" do
        assert_equal 10, SelectedProject.count, "there should be 10 selected projects"
      end
      context "allocate project to student1" do
        setup do
          @pa = @project.allocate(@student, 1)
          @student.reload
        end
        should "be allocated" do
          assert_not_nil @pa, "Project wasn't allocated"
        end
        should "no longer be available" do
          assert ! @project.available?, "project 3 should now be unavailable"
        end
        should "return a valid project allocation record" do
          assert_equal 1, @pa.allocation_round, "allocation round wasn't 1"
          assert_equal @student.id, @pa.student_id, "student should be allocated"
          assert_equal @project.id, @pa.project_id, "project should be allocated"
          assert_equal @project.supervisor.id, @pa.supervisor_id, "supervisor should be allocated"
        end
        should "properly manage selections" do
          assert_nil @student.project_selection, "student 3 has no project selection"
          assert_equal 4, SelectedProject.count, "project selections have not been dettached"
        end
      end
    end
  end

  context "allocating a project with errors" do
    setup do
      @project = projects(:project3)
      @student = students(:student1)
    end

    context "fail to allocate if not available" do

      context "project already allocated" do
        setup do
          @project.allocate(students(:student2), 10)
        end

        should "fail to allocate" do
          assert_raise RuntimeError do
            @project.allocate(@student, 1)
          end
        end
      end

      context "supervisor is at capacity" do
        setup do
          @project.supervisor.load = 4
        end

        should "fail to allocate" do
          assert_raise RuntimeError do
            @project.allocate(@student, 1)
          end
        end
      end

      context "not available flag is set" do
        setup do
          @project.available = false
          @project.save
        end

        should "fail to allocate" do
          assert_raise RuntimeError do
            @project.allocate(@student, 1)
          end
        end
      end
    end

    should "should fail due to argument errors" do
      assert_raise RuntimeError do
        @project.allocate(nil, 1)
      end
      pa = @project.allocate(@student)
      assert_equal 1, pa.allocation_round,"Should assign default round if none given"
    end

    should "fail if project doesn't have a supervisor" do
      # This should never happen!
      @project.created_by = users(:no_role_user)
      assert_raise RuntimeError do
        @project.allocate(@student, 1)
      end
    end
  end

  context "deallocating a project" do
    setup do
      @project = projects(:project3)
      @student = students(:student1)
      @project.allocate(@student, 1)
    end

    should "have correct initial conditions" do
      assert @project.allocated?
      assert ! @project.available?
      assert_equal 1, @project.supervisor.load
      assert_not_nil @student.project
    end


    should "deallocate project" do
      @project.deallocate
      assert ! @project.allocated?
      assert @project.available?
      assert_equal 0, @project.supervisor.load
    end
  end
end