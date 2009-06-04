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
class User::AccountsController < ApplicationController
  current_tab :my_account
  before_filter :login_required, :only =>  [ :show, :edit, :update ]
  before_filter :login_prohibited, :only => [:new, :create]

  # This show action only allows users to view their own profile
  def show
    @user = current_user
  end

  def edit
		@user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated."
      redirect_to :action => 'show'
    else
			flash.now[:error] = "There was a problem updating your profile."
      render :action => 'edit'
    end
  end

end
