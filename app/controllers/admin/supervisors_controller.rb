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
class Admin::SupervisorsController < ApplicationController
  current_tab :admin
  require_role "admin"
  
  #
  ## GET /admin/supervisors
  # GET /admin/supervisors.xml
  def index
    @supervisors = Supervisor.find(:all, :order => "user_id")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @supervisors }
    end
  end

  # GET /admin/supervisor/1
  # GET /admin/supervisor/1.xml
  def show
    @supervisor = Supervisor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supervisor }
    end
  end

  # GET /admin/supervisors/new
  # GET /admin/supervisors/new.xml
  def new
    @supervisor = Supervisor.new
    @users = User.find(:all, :order => "last_name, first_name")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @supervisor }
    end
  end

  # GET /admin/supervisors/1/edit
  def edit
    @supervisor = Supervisor.find(params[:id])
  end

  # POST /admin/supervisors
  # POST /admin/supervisors.xml
  def create
    @supervisor = Supervisor.new(params[:supervisor])
    @supervisor.user.add_role(Role.find_by_name("staff"))

    respond_to do |format|
      if @supervisor.save
        flash[:notice] = 'supervisor was successfully created.'
        format.html { redirect_to(@supervisor) }
        format.xml  { render :xml => @supervisor, :status => :created, :location => @supervisor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @supervisor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/supervisors/1
  # PUT /admin/supervisors/1.xml
  def update
    @supervisor = Supervisor.find(params[:id])

    respond_to do |format|
      if @supervisor.update_attributes(params[:user])
        flash[:notice] = 'supervisor was successfully updated.'
        format.html { redirect_to(admin_supervisor_path(@supervisor)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supervisor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/supervisors/1
  # DELETE /admin/supervisors/1.xml
  def destroy
    @supervisor = Supervisor.find(params[:id])
    @supervisor.user.delete_role(Role.find_by_name("staff"))
    @supervisor.destroy

    respond_to do |format|
      format.html { redirect_to(admin_supervisors_path) }
      format.xml  { head :ok }
    end
  end

end
