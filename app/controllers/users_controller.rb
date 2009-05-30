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
class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => ["new", "create"]
  require_role ["admin"], :for => ["index", "edit", "update", "destroy"]
  # TODO: handle other methods?
  # 
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if params[:staff_or_student] == "staff"
      supervisor = Supervisor.new(:user_id => @user.id, :research_centre_id => ResearchCenter.find_by_abbrev(params[:research_centre]))
      supervisor.save
      logger.info "User #{@user.id} added as supervisor #{supervisor.id}"
    elsif params[:staff_or_student] == "student"
      student = Student.new(:user_id => @user.id, :discipline => Disciplines.find_by_name(params[:discipline]))
      student.save
      logger.info "User #{@user.id} added as student #{student.id}"
    end
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We need to confim your status and will be in touch shortly."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  def update
  	
  end
end
