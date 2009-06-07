#  Copyright 2009 Swansea University.
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  under the License.

require 'test_helper'

class StatusSettingsPermissionsTest < ActionController::IntegrationTest
  fixtures :status_settings, :users

  def test_login
    # get the login page
    get "/login"
    assert_equal 200, status

    # post the login and follow through to the home page
    post "/login", :username => users(:admin).login, :password => 'monkey'
    follow_redirect!
    assert_equal 200, status
    assert_equal "/home", path
  end

  test "on create permissions are correctly converted to Permission object" do
    login_as users(:admin)

    get "/admin/status_settings"
    assert_response :success
    assert_template :index
  end
end

