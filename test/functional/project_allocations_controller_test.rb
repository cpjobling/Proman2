require 'test_helper'

class ProjectAllocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_allocations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_allocation" do
    assert_difference('ProjectAllocation.count') do
      post :create, :project_allocation => { }
    end

    assert_redirected_to project_allocation_path(assigns(:project_allocation))
  end

  test "should show project_allocation" do
    get :show, :id => project_allocations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_allocations(:one).to_param
    assert_response :success
  end

  test "should update project_allocation" do
    put :update, :id => project_allocations(:one).to_param, :project_allocation => { }
    assert_redirected_to project_allocation_path(assigns(:project_allocation))
  end

  test "should destroy project_allocation" do
    assert_difference('ProjectAllocation.count', -1) do
      delete :destroy, :id => project_allocations(:one).to_param
    end

    assert_redirected_to project_allocations_path
  end
end
