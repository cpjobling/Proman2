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
class Admin::UsersController < ApplicationController

  current_tab :admin
  require_role "admin"

  # GET /admin/users
  # GET /admin/users.xml
  def index
    @users = User.find(:all, :order=>"last_name, first_name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin/user/1
  # GET /admin/user/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
    @roles = Role.find(:all)
    if @user.has_role?("student")
      @student = Student.find_by_user_id(@user.id)
    elsif @user.has_role?("staff")
      @supervisor = Supervisor.find_by_user_id(@user.id)
    end
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    @user = User.new(params[:user])
    clear_notices
    respond_to do |format|
      success = @user && @user.save
      if success && @user.errors.empty?
        info_message "Added new user #{@user.id}."
        if @user.has_role?("staff")
          @staff_or_student = "staff"
          create_supervisor
        elsif @user.has_role?("student")
          @staff_or_student = "student"
          create_student
        end
        info_message "New user @user.name added as #{@staff_or_student}"
        format.html { redirect_to admin_users_path }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        error_message "We couldn't create that new user, sorry.  Please try again, or contact an admin (link is above)."
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])
    clear_notices
    respond_to do |format|
      if @user.update_attributes(params[:user])
        logger.info "Updated user #{@user.id}."
        if @user.has_role?("staff")
          update_supervisor
        elsif @user.has_role?("student")
          update_student
        end
        info_message "User #{@user.id} was successfully updated."
        format.html { redirect_to(admin_user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_path) }
      format.xml  { head :ok }
    end
  end

  private

  def create_supervisor
    supervisor = Supervisor.new(params[:supervisor])
    supervisor.user_id = @user.id
    supervisor.save
    info_message "User #{@user.id} added as supervisor #{supervisor.id}"
  end

  def create_student
    student = Student.new(params[:student])
    student.user_id = @user.id
    if student.save
      info_message "User #{@user.id} added as student #{student.id}"
    else
      error_message "Couldn't create student record for #{@user.id}!"
    end
  end

  def update_supervisor
    @supervisor = Supervisor.find_by_user_id(@user.id)
    if ! @supervisor
      # No such record: create new Supervisor
      create_supervisor
    elsif @supervisor.update_attributes(params[:supervisor])
      info_message "Supervisor #{@user.name} updated."
    else
      error_message "Couldn't update supervisor details for #{@user.name}."
    end
  end
  
  def update_student
    @student = Student.find_by_user_id(@user.id)
    if ! @student
      # No such record: create new Student
      create_student
    elsif @student.update_attributes(params[:student])
      info_message "Student #{@user.name} updated."
    else
      error_message "Couldn't update student details for #{@user.name}."
    end
  end
  
  def clear_notices
    flash[:notice] = ""
    flash[:error] = ""
  end

  def error_message(message)
    flash[:error] += message + "<br />"
    logger.error message
  end

  def info_message(message)
    flash[:notice] += message + "<br />"
    logger.info message
  end
end