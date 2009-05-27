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
# 
# Tests project access rules
#
require 'test_helper'
require 'projects_controller'

class ProjectsControllerAccessRulesTest < ActionController::TestCase

  fixtures :projects, :users, :roles, :roles_users

  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "anyone should be able to access index" do
    assert_users_access(
      {:admin => true, :academic => true, :student => true, :coordinator => true, :new_user => true}, # accessible to all
      "index"          # test the index action
    )
    get :index # also open to public
    assert_response :success
  end

  test "anyone should be able to access by_supervisor" do
    assert_users_access(
      {:admin => true, :academic => true, :student => true, :coordinator => true, :new_user => true}, # accessible to all
      "by_supervisor"  # by_supervisor
    )
    get :by_supervisor # also open to public
    assert_response :success
  end

  test "anyone should be able to access by_discipline" do
    assert_users_access(
      {:admin => true, :academic => true, :student => true, :coordinator => true, :new_user => true}, # accessible to all
      "by_discipline"  # by_discipline
    )
    get :by_discipline # also open to public
    assert_response :success
  end

  test "anyone should be able to access by_centre" do
    assert_users_access(
      {:admin => true, :academic => true, :student => true, :coordinator => true, :new_user => true}, # accessible to all
      "by_centre"     # by_centre
    )
    get :by_centre # also open to public
    assert_response :success
  end

  test "anyone should be able to access show project" do
    assert_users_access(
      {:admin => true, :academic => true, :student => true, :coordinator => true, :new_user => true}, # accessible to all
      "show",     # by_centre
      :id => projects(:project1).id
    )
    get :show, :id => projects(:project1).id # also open to public
    assert_response :success
  end

  test "only staff users should get new" do
    assert_users_access(
      {:admin => true, :academic => true, :coordinator => true, :student => false, :new_user => false}, # accessible logged in staff
      "new"
    )
  end

  test "must be logged in" do
  	get :new
    assert_redirected_to new_session_path
  end

  test "student cant add a new project" do
    login_as :student
    get :new
    assert_response :unauthorized
  end

  test "staff can add a new project" do
    login_as :academic
    get :new
    assert :success
  end

  test "coordinator can add a new project" do
    login_as :coordinator
    get :new
    assert :success
  end

  test "admin can add a new project" do
    login_as :admin
    get :new
    assert :success
  end

  test "should create project" do
  	login_as :academic
    assert_difference('Project.count') do
      post :create, :project => {:title => "A test project",
        :description => "A dummy project",
        :created_by => users(:academic).id}
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should get edit" do
  	login_as :academic
    get :edit, :id => projects(:project1).id
    assert_response :success
  end

  test "should update project" do
  	login_as :academic
    put :update, :id => projects(:project1).id, :project => { }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
  	login_as :academic
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:project1).id
    end

    assert_redirected_to projects_path
  end

  test "staff can destroy own project" do
    login_as :academic
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:project1).id
    end
  end

  test "staff can update own project" do
    login_as :academic
    put :update, :id => projects(:project1).id, :project => { :title => "Project x",
      :description => "Blah, blah, blah"}
    assert_response :redirect
  end

  test "staff can edit own project" do
    login_as :academic
    get :edit, :id => projects(:project1).id
    assert_response :success
  end

  test "staff cannot destroy someone else's project" do
    login_as :new_user
    users(:new_user).add_role(roles(:staff_role))
    delete :destroy, :id => projects(:project1).id
    assert_response :unauthorized
    # TODO: make this test pass
  end

  test "staff cannot update someone else's project" do
    login_as :new_user
    users(:new_user).add_role(roles(:staff_role))
    put :update, :id => projects(:project1).id, :project => { :title => "Project x",
      :description => "Blah, blah, blah"}
    assert_response :unauthorized
    # TODO: make this test pass
  end

  test "staff cannot edit someone else's project" do
    login_as :new_user
    users(:new_user).add_role(roles(:staff_role))
    get :edit, :id => projects(:project1).id
    assert_response :unauthorized
    # TODO: make this test pass
  end

  # Admin users
  test "admin user can destroy any project" do
    login_as :admin
    the_projects = Project.all
    the_projects.each do |p|
      assert_difference('Project.count', -1) do
        delete :destroy, :id => p.id
      end
    end
  end

  test "admin user can update any project" do
    login_as :admin
    the_projects = Project.all
    the_projects.each do |p|
      put :update, :id => p.id, :project => { :title => "Project #{p.id}",
        :description => "Blah, blah, blah"}
      assert_response :redirect
    end
      
  end

  test "admin user can edit any project" do
    login_as :admin
    the_projects = Project.all
    the_projects.each do |p|
      get :edit, :id => p.id
      assert_response :success
    end
  end

  # Coordinator users
  test "coordinatot user can destroy any project" do
    login_as :coordinator
    the_projects = Project.all
    the_projects.each do |p|
      assert_difference('Project.count', -1) do
        delete :destroy, :id => p.id
      end
    end
  end

  test "coordinator user can update any project" do
    login_as :coordinator
    the_projects = Project.all
    the_projects.each do |p|
      put :update, :id => p.id, :project => { :title => "Project #{p.id}",
        :description => "Blah, blah, blah"}
      assert_response :redirect
    end

  end

  test "coordinator user can edit any project" do
    login_as :coordinator
    the_projects = Project.all
    the_projects.each do |p|
      get :edit, :id => p.id
      assert_response :success
    end
  end
end
