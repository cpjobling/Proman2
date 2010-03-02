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
class User::PasswordSettingsController < ApplicationController
  current_tab :my_account
  before_filter :login_required

  # Change password view
  def index

  end
  
  # Change password action  
  def create
		if current_user.change_password!(params[:old_password], params[:password], params[:password_confirmation])
   		flash[:notice] = "Password successfully updated."
    	redirect_to user_account_path(current_user)
		else
			@old_password = nil
      flash.now[:error] = current_user.errors.on_base || "There was a problem updating your password."
      render :action => 'index'
		end
	end

end
