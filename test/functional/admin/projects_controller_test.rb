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

class Admin::ProjectsControllerTest < ActionController::TestCase
  fixtures :users, :supervisors, :projects, :disciplines

  def setup
    login_as users(:cpj)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, :project => { :title=> "test", :description=>"test", :supervisor_id=>supervisors(:cpjobling).id }
    end
    # Check referential integrity
    p = Project.find(assigns(:project))
    assert_equal supervisors(:cpjobling), p.supervisor
    assert_redirected_to admin_project_path(assigns(:project))
  end

  test "should show project" do
    get :show, :id => projects(:project1).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => projects(:project1).to_param
    assert_response :success
  end

  test "should update project" do
    put :update, :id => projects(:project1).to_param, :project => { }
    assert_redirected_to admin_project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:project1).to_param
    end
    assert_redirected_to admin_projects_url
  end
end
