require 'test_helper'

class ProjectSelectionsControllerTest < ActionController::TestCase

  fixtures :users, :students, :disciplines, :projects, :status_settings

  def setup
    @student1 = students(:student1)
    @student2 = students(:student2)
    @student3 = students(:student3)
    @student4 = students(:student4)
    @student5 = students(:student5)
  end

  context "student5 in a selection round" do
    setup do
      selection_round_one
      login_as @student5.user
    end

    should "be selection round 1" do
      assert_equal 1, @status.selection_round
    end

    context "index when student 5 has no project selection" do
      setup { get :index }
      should_assign_to :status
      should_assign_to :student
      should_assign_to :selection_round
      should_render_template :index
      should_not_set_the_flash
      should_respond_with :success

      should "initially have no projects" do
        assert_select "p#projects", :text => /You do not yet have a round 1 project selection./
      end

      should "page title and header contain the selection round" do
        assert_select "title", :text => /[R|r]ound 1/
        assert_select "h2", :text => /[R|r]ound 1/
      end

      should "have a link to create ps" do
        url = new_project_selection_path
        assert_select "p#projects a[href=#{url}]", :text => /create a new project selection/
      end
    end

    context "index when student 5 has an empty project selection" do
      setup do
        @student5.project_selection = ProjectSelection.new(:student => @student5, :round => @status.selection_round)
        get :index
      end

      should "initially have an empty project selection" do
        assert_select "p#projects", :text => /empty/
      end

      should "page title and header contain the selection round" do
        assert_select "title", :text => /[R|r]ound 1/
        assert_select "h2", :text => /[R|r]ound 1/
      end

      should "have a link to add projects" do
        url = new_project_selection_path
        assert_select "p#projects a[href=#{url}]", :text => /add some projects/
      end
    end

    context "index when student 5 has a project selection" do
      setup do
        @student5.project_selection = ProjectSelection.new(:student => @student5, :round => @status.selection_round)
        SelectedProject.create(:project_selection => @student5.project_selection, :project => projects(:project1))
        get :index
      end

      should "have a table" do
        assert_select "table#projects"
      end

      should "have a link to edit project selection" do
        url = edit_project_selection_path(assigns(:project_selection))
        assert_select "p a[href=#{url}]", :text => /Add some more projects/
      end

      should "have a link to rank project selection" do
        url = project_selection_selected_projects_path(assigns(:project_selection))
        assert_select "p a[href=#{url}]", :text => /Rank your project selections/
      end

      should "have a link to start over" do
        url = project_selection_path(assigns(:project_selection))
        assert_select "p a[href=#{url}]", :text => /Start over/
      end
    end
  end

  context "student2 in a selection round" do
    setup do
      selection_round_one
      allocate(projects(:project2), @student1)
      allocate(projects(:project5), @student3)
      login_as @student2.user
      get :new
    end

    context "new project selection" do
      should_assign_to :status
      should_assign_to :student
      should_assign_to :selection_round
      should_assign_to :project_selection
      should_assign_to :projects
      should_render_template :new
      should_not_set_the_flash
      should_respond_with :success
    end

    context "new parameters" do
      setup do
        @projects = assigns(:projects)
      end

      should "find available projects" do
        assert_equal 3, @projects.size, "There should be 5 available projects"
        @projects.each do |p|
          assert p.available?, "Project #{p.id} should be available"
          assert p.suitable_for?(@student2.discipline), "Project #{p.id} should be suitable for student 2"
        end
      end

      should "not find unavailable projects" do
        [2, 5].each do |p|
          assert available_project = Project.find(p), "Should find project #{p}"
          assert available_project.suitable_for?(@student2.discipline), "Project #{p} should be suitable for student 2"
          assert ! available_project.available?, "Project #{p} should be unavailable"
        end
      end

      should "not find projects from another discipline" do
        [1, 3, 4, 7, 9, 10, 11, 12, 13, 14].each do |p|
          assert available_project = Project.find(p), "Should find project #{p}"
          assert available_project.available, "Project #{p} should be available"
          assert ! available_project.suitable_for?(@student2.discipline), "Project #{p} should be suitable for student 2"
        end
      end

      context "new project selection page" do

        should "contain the selection round" do
          assert_select "div.col1 h2", :text => /[R|r]ound 1/
        end

        should_render_a_form
      end
    end
  end

  context "In an allocation round" do

    setup do
      login_as :student2
      allocation_round_one
    end

    should "be selection round 1" do
      assert_equal 1, @status.selection_round
    end

    context "allow get index" do
      setup { get :index }
      should_respond_with 200
    end

    context "request rejected by before_filter can_select_projects" do
      setup { get :edit,  :id => project_selections(:two).to_param }
      should_respond_with 302
      should_set_the_flash_to "Project selection is not enabled at this time."
      should_redirect_to "projects_path"
    end
  end

  context "the before filter get_student and get_project_selection" do

    setup do
      selection_round_one
    end

    context "not a student" do
      setup do
        login_as :academic
        get :index
      end
      should_respond_with :unauthorized
    end

    context "logged in as a student who doesn't have a project selection" do
      setup do
        login_as :student5
        get :index
      end

      should  "assign to @student" do
        assert_not_nil assigns(:student), "@student should be assigned"
        assert_equal @student5, assigns('student'), "Student 5 should be assigned to @student"
      end

      should "find a nil project_selection" do
        @student = assigns(:student)
        assert_nil @student.project_selection
      end

      should "assign a nil @project_selection" do
        assert_nil assigns(:project_selection), "@project_selection should be nil"
      end

    end

    context "logged in as a student who has a project selection" do
      setup do
        login_as :student2
        get :index
      end

      should  "assign to @student" do
        assert_not_nil assigns(:student), "@student should be assigned"
        assert_equal @student2, assigns(:student), "Student should be assigned to @student"
      end

      should "assign to @project_selection" do
        assert assigns(:project_selection), "@project_selection should be assigned"
      end

      should "return an existing project_selection" do
        @student = assigns(:student)
        assert_not_nil @student.project_selection
        assert_equal @student.project_selection.student, @student2
        assert_equal @student.project_selection, assigns['project_selection']
      end

      should "call verify_ownership for owner and succeed" do
        ps = assigns['project_selection']
        assert_equal @student2, ps.student
        assert_response :success
      end
    end
  end

  context "before_filter verify_ownership for logged in student who is not the owner of the requested project selection" do
    setup do
      login_as :student3
      selection_round_one
      get :edit, :id => project_selections(:two).to_param
    end
    should_assign_to :student
    should_assign_to :ps
    should "not be nil" do
      ps = assigns(:ps)
      assert_not_nil ps, "PS was nil"
    end
    should "invalidate the test conditions" do
      ps = assigns(:ps)
      student = assigns(:student)
      assert_equal @student3, student, "logged in student wasn't student3"
      assert_equal @student2, ps.student, "project selection wasn't owned by student2"
      assert_not_equal student, ps.student, "should not be equal"
      assert_not_equal ps, student.project_selection, "project selections should be different"
    end
    should_set_the_flash_to /not permitted/
    should "redirect to index" do
      assert_redirected_to project_selections_path
    end
  end

  context "student requests a new project selection" do
    setup do
      login_as :student5
    end

    should "get new" do
      get :new
      assert_response :success
    end

  end

  context "student edits a project selection" do
    setup do
      login_as :student2
      selection_round_one
    end

    should "get edit" do
      get :edit, :id => project_selections(:two).to_param
      assert_response :success
    end

    should "update project_selection" do
      put :update, :id => project_selections(:two).to_param, :project_selection => { }
      assert_redirected_to project_selection_selected_projects_path(assigns(:project_selection))
    end

    should "destroy project_selection" do
      assert_difference('ProjectSelection.count', -1) do
        delete :destroy, :id => project_selections(:two).to_param
      end

      assert_redirected_to project_selections_path
    end
  end

  context "student has an allocated project" do
    setup do
      login_as :student1
      @student = users(:student1).student
      selection_round_one
    end

    should "get index" do
      get :index
      assert_response :success
      assert_select "p#allocated-project", :text => /Congratulations/
    end

    should "get edit" do
      get :edit, :id => project_selections(:two).to_param
      assert_redirected_to user_account_path(@student.user)
      assert flash[:notice] =~ /You appear to have been allocated a project/
    end

    should "update project_selection" do
      put :update, :id => project_selections(:two).to_param, :project_selection => { }
      assert_redirected_to user_account_path(@student.user)
      assert flash[:notice] =~ /You appear to have been allocated a project/
    end

    should "destroy project_selection" do
      assert_difference('ProjectSelection.count', 0) do
        delete :destroy, :id => project_selections(:two).to_param
      end
      assert flash[:notice] =~ /You appear to have been allocated a project/
      assert_redirected_to user_account_path(@student.user)
    end
  end

  private

  def selection_round_one
    @status = Status.find(1)
    @status.status_setting = status_settings(:selection1)
    @status.save
  end

  def allocation_round_one
    @status = Status.find(1)
    @status.status_setting = status_settings(:allocation1)
    @status.save
  end

  def allocate(project, student)
    project.allocate(student, 1)
  end

end