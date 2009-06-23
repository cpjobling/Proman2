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
      {:admin => true, :academic => true, :student1 => true, :coordinator => true, :no_role_user => true }, # accessible to all
      "index"          # test the index action
    )
    get :index # also open to public
    assert_response :success
  end

  test "anyone should be able to access by_supervisor" do
    assert_users_access(
      {:admin => true, :academic => true, :student1 => true, :coordinator => true, :no_role_user => true}, # accessible to all
      "by_supervisor"  # by_supervisor
    )
    get :by_supervisor # also open to public
    assert_response :success
  end

  test "anyone should be able to access by_discipline" do
    assert_users_access(
      {:admin => true, :academic => true, :student1 => true, :coordinator => true, :no_role_user => true}, # accessible to all
      "by_discipline"  # by_discipline
    )
    get :by_discipline # also open to public
    assert_response :success
  end

  test "anyone should be able to access by_centre" do
    assert_users_access(
      {:admin => true, :academic => true, :student1 => true, :coordinator => true, :no_role_user => true}, # accessible to all
      "by_centre"     # by_centre
    )
    get :by_centre # also open to public
    assert_response :success
  end

  test "anyone should be able to access show project" do
    assert_users_access(
      {:admin => true, :academic => true, :student1 => true, :coordinator => true, :no_role_user => true}, # accessible to all
      "show",     # by_centre
      :id => projects(:project1).id
    )
    get :show, :id => projects(:project1).id # also open to public
    assert_response :success
  end

end


