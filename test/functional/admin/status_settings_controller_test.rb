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

class Admin::StatusSettingsControllerTest < ActionController::TestCase
  fixtures :status_settings, :users

  def setup
    login_as users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end


  test "should create status setting" do
    assert_difference('StatusSetting.count') do
      post :create, :status_setting => { :code=> "5123", :title => "test", :message=>"test", :octal_permissions=>"70000" }
    end

    assert_redirected_to admin_status_setting_path(assigns(:setting))
  end


  test "should show status_setting" do
    get :show, :id => status_settings(:allocation1).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => status_settings(:allocation1).to_param
    assert_response :success
  end

  test "should update status_setting" do
    put :update, :id => status_settings(:allocation1).to_param, 
        :status_setting => { :code=> "5123", :title => "test", :message=>"test", :octal_permissions=>"70000" }
    assert_redirected_to admin_status_setting_path(assigns(:setting))
  end

  test "should destroy status_setting" do
    assert_difference('StatusSetting.count', -1) do
      delete :destroy, :id => status_settings(:allocation1).to_param
    end
    assert_redirected_to admin_status_settings_url
  end
end
