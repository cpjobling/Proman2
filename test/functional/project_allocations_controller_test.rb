require 'test_helper'

class ProjectAllocationsControllerTest < ActionController::TestCase
  def setup
    login_as users(:coordinator)
    status = Status.find(1)
    status.status_setting = status_settings(:allocation1)
    status.save
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_allocations)
    assert_not_nil assigns(:allocation_round)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:project_allocation)
    assert_not_nil assigns(:allocation_round)
    assert_not_nil assigns(:project_selections)
  end

  test "should create project_allocation" do
    assert_difference('ProjectAllocation.count',2) do
      post :create, :project_allocation => { 
        :selected_projects => [(selected_projects(:s1_p1).id).to_s, (selected_projects(:s2_p3).id).to_s],
        :allocation_round => '1'
      }
    end
    assert_not_nil assigns(:selected_projects)
    assert_equal 2, assigns(:selected_projects).size
    assert_not_nil assigns(:project_allocations)
    assert_equal 2, assigns(:project_allocations).size

    assert_redirected_to new_project_allocation_path
  end

  test "should show project_allocation" do
    get :show, :id => project_allocations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_allocations(:one).to_param
    assert_response :success
    assert_not_nil assigns(:project_allocation)
    assert_not_nil assigns(:allocation_round)
  end

  test "should update project_allocation" do
    put :update, :id => project_allocations(:one).to_param, :project_allocation => { }
    assert_not_nil assigns(:project_allocation)
    assert_redirected_to project_allocation_path(assigns(:project_allocation))
  end

  test "should destroy project_allocation" do
    assert_difference('ProjectAllocation.count', -1) do
      delete :destroy, :id => project_allocations(:one).to_param
    end

    assert_redirected_to project_allocations_path
  end
end
