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

  # Table name: supervisors
  #
  #  id                 :integer         not null, primary key
  #  research_centre_id :integer
  #  user_id            :integer
  #  staff_id           :string(255)
  #  created_at         :datetime
  #  updated_at         :datetime
  #  loading            :integer         default(4)

  should_validate_presence_of :user_id, :staff_id, :research_centre_id, :loading
  should_ensure_length_in_range :staff_id, (5..10)
  should_validate_numericality_of :staff_id, :research_centre_id, :user_id, :loading
  should_validate_uniqueness_of :staff_id
  
  #should_have_many :students, :through => :project_allocations, :class => 'project_allocation'
  should_belong_to :user, :research_centre

  
  context "a user" do
    setup do
      @user = users(:cpj)
    end
    
    should "be associated with a supervisor" do
      assert_equal supervisors(:cpjobling), @user.supervisor
    end
  
    context "and a user's projects" do
      setup do
        @supervisor = supervisors(:cpjobling)
        @projects = @user.projects
      end

      should "have many projects" do
        assert_not_nil @projects
        assert_equal 4, @projects.count
      end

      should "each be created by the user" do
        @projects.each do |project|
          assert_equal @user.id, project.created_by
          assert_equal @user, User.find(project.created_by)
        end
      end
    end
  end

  context "a supervisor" do
    setup do
      @supervisor = supervisors(:cpjobling)
      @user = @supervisor.user
    end

    should "have a user" do
      assert_not_nil @user
      assert_equal users(:cpj), @user
    end

    should "have a user with the correct id" do
      @user.id = users(:cpj).id
    end

    should "have a user with role 'staff'" do
      assert @user.has_role?('staff')
    end

    should "have a user with the correct name" do
      assert_equal "Dr Christopher P. Jobling", @user.name.to_s
    end

    should "have valid attributes" do
      assert_equal "039934", @supervisor.staff_id
      assert_equal  research_centres(:mnc), @supervisor.research_centre
      assert_equal 4, @supervisor.loading
    end

    should "be able to access projects by delegation" do
      assert_not_nil @supervisor.projects
      assert_equal 4, @supervisor.projects.count
    end

    should "be able to access useful user fields by delegation" do
      assert_equal @user.name, @supervisor.name
      assert_equal @user.email, @supervisor.email
    end

    should "be able to access research centre abbrev and title via delation" do
      rc = research_centres(:mnc)
      assert_equal rc.abbrev, @supervisor.rc_abbrev
      assert_equal rc.title, @supervisor.rc_title
    end

  end



  context "a supervisor with a loading" do
    setup do
      @supervisor = supervisors(:mgedwards)
    end

    should "have default loading" do
      assert_equal 4, @supervisor.loading
    end

    should "add a student" do
      assert_equal 0, @supervisor.load
    end

    should "access load through accessors" do
      @supervisor.load = 2
      assert_equal 2, @supervisor.load
    end

    should "report availabilty via load" do
      @supervisor.load = 3
      assert ! @supervisor.has_full_allocation?
      @supervisor.load = 4
    end
    
    should "fail to add a student when fully loaded" do
      @supervisor.load = 4
      assert @supervisor.has_full_allocation?
      assert_raise RuntimeError do
        @supervisor.add_student
      end
    end

    should "add one student" do
      @supervisor.load = 1
      @supervisor.add_student
      assert_equal 2, @supervisor.load
    end

    should "remove one student" do
      @supervisor.load = 1
      @supervisor.remove_student
      assert_equal 0, @supervisor.load
    end

    should "not be able to have a negative load" do
      @supervisor.load = 0
      @supervisor.remove_student
      assert_equal 0, @supervisor.load
    end
  end
end
