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

  context "In a selection round" do
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
        assert_select "p#projects", :text => /.*empty.* add some projects/
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

    context "new project selection" do
      setup { get :new }
      should_assign_to :status
      should_assign_to :student
      should_assign_to :selection_round
      should_render_template :new
      should_not_set_the_flash
      should_respond_with :success
    end

    context "show page" do
      setup { get :index }
      should "initially have no projects" do
        assert_select "p#projects", :text => /Your round 1 project selection list is empty./
      end

      should "contain the selection round" do
        assert_select "h2", :text => /[R|r]ound 1/
      end

      should "have a link to edit ps 1" do
        url = new_project_selection_path
        assert_select "p#projects a[href=#{url}]", :text => /add some projects/
      end
    end
    
  end
  context "In an allocation round" do

    setup do
      allocation_round_one
    end

    should "be selection round 1" do
      assert_equal 1, @status.selection_round
    end

    context "request rejected by before_filter can_select_projects" do
      setup { get :index }
      should_assign_to :status
      should_respond_with 302
      should_set_the_flash_to "Project selection is not enabled at this time."
      should_redirect_to "projects_path"
    end
  end

  test "before_filter find_student_and_project_selection assigns a student" do
    get :index
    assert_not_nil assigns('student')
    assert_equal @student1, assigns('student'), "Student should be assigned to @student"
  end

  test "before_filter find_student_and_project_selection creates a new project_selection" do
    assert_difference('ProjectSelection.count') do
      get :index
    end
    @student = assigns['student']
    assert_not_nil @student.project_selection, "New PS created"
    assert_equal @student.project_selection.student, @student
    assert_equal @student.project_selection.round, Proman::Config.current_selection_round
    assert_equal @student.project_selection, assigns['project_selection']
  end

  test "before_filter find_student_and_project_selection returns an existing project_selection" do
    ps = ProjectSelection.create(:student => @student1, :round => Proman::Config.current_selection_round)
    assert_no_difference('ProjectSelection.count') do
      get :index
    end
    @student = assigns['student']
    assert_not_nil @student.project_selection
    assert_equal @student.project_selection.student, @student1
    assert_equal ps, assigns['project_selection']
  end

  test "before_filter verify_ownership for owner succeeds" do
    get :index
    student = assigns['student']
    ps = assigns['project_selection']
    alleged_owner = @student1
    assert_response :success
  end

  test "before_filter verify_ownership for non-owner should fail and redirect" do
    login_as @student2.user # owns PS 2
    # attempt to access original user's project selection
    get :show, :id => project_selections(:one).to_param
    assert_equal "You are not permitted to access another student's project selection. This access attempt has been logged.", flash[:notice]
    assert_redirected_to :action => "index"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_selections)
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_template :help
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_selection" do
    assert_difference('ProjectSelection.count') do
      post :create, :project_selection => { }
    end

    assert_redirected_to project_selection_path(assigns(:project_selection))
  end

  test "should show project_selection" do
    get :show, :id => project_selections(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_selections(:one).to_param
    assert_response :success
  end

  test "should update project_selection" do
    put :update, :id => project_selections(:one).to_param, :project_selection => { }
    assert_redirected_to project_selection_path(assigns(:project_selection))
  end

  test "should destroy project_selection" do
    assert_difference('ProjectSelection.count', -1) do
      delete :destroy, :id => project_selections(:one).to_param
    end

    assert_redirected_to project_selections_path
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
end
