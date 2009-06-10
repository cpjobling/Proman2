require 'test_helper'

class ProjectSelectionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_selections)
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
