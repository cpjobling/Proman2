require 'test_helper'

class ProjectSelectionsControllerTest < ActionController::TestCase

  fixtures :users, :students, :disciplines, :projects

  def setup
    Proman::Config.current_selection_round = 1
    Proman::Config.can_select = true
    @student1 = students(:student1)
    @student2 = students(:student2)
    login_as :student1
  end

  def test current_round
    assert_equal 1, current_selection_round
  end

  test "doesn't allow selection when selection turned off then on" do
    Proman::Config.can_select = false
    get :index
    assert_response 302, "Expected error for action => :index"
    Proman::Config.can_select = true
    get :index
    assert_response 200
  end

  test "before_filter can_select_projects" do
    Proman::Config.can_select = false
    get :index
    assert_equal "Project selection is not enabled at this time.", flash[:notice]
    assert_redirected_to projects_path, "Should redirect to projects index"
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
    login_as :student2 # owns PS 2
    # attempt to access original user's project selection
    get :show, :id => project_selections(:one).to_param
    #assert_equal "You are not permitted to access another student's project selection. This access attempt has been logged.", flash[:notice]
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
end
