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


class ProjectAllocationsController < ApplicationController


  require_role "coordinator", :for_all_except => [:index, :show]
  before_filter :get_status
  before_filter :can_allocate_projects?, :except => [:index, :show]
  

  # GET /project_allocations
  # GET /project_allocations.xml
  def index
    @project_allocations = ProjectAllocation.all
    @allocation_round = @status.selection_round

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_allocations }
    end
  end

  # GET /project_allocations/1
  # GET /project_allocations/1.xml
  def show
    @project_allocation = ProjectAllocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_allocation }
    end
  end

  # GET /project_allocations/new
  # GET /project_allocations/new.xml
  def new
    @project_allocation = ProjectAllocation.new
    @allocation_round = @status.selection_round
    @project_selections = ProjectSelection.all
    respond_to do |format|
      format.html { render :layout => "worksheet" }
      format.xml  { render :xml => @project_allocation }
    end
  end

  # GET /project_allocations/1/edit
  def edit
    @project_allocation = ProjectAllocation.find(params[:id])
    @allocation_round = @status.selection_round
    @students = Student.find(:all, :joins => :user, :order => ['users.last_name, users.first_name'])
  end

  # POST /project_allocations
  # POST /project_allocations.xml
  def create
    #@project_allocation = ProjectAllocation.make(params[:project_allocation])
    pa_data = params[:project_allocation]
    @selected_projects = SelectedProject.find(pa_data[:selected_projects])
    begin
      @project_allocations = []
      @selected_projects.each do |selected_project|
        unless selected_project.nil? # An earlier allocation may have de-allocated this selection
          @project_allocations << selected_project.allocate_project unless selected_project.nil?
        end
      end
    rescue RuntimeError => e
      message = "ProjectAllocation failed for #{selected_project.id} #{e.message}"
    end
    respond_to do |format|
      if message
        if @project_allocations.size > 0
          flash[:notice] = "#{@project_allocations.size} project allocations were successfully created."
        end
        flash[:notice] += "But project #{selected_project.project_id} failed to allocate. Additional information: #{message}. Try again?"
        format.html { render :action => "new" }
        # format.xml  { render :xml => @project_allocation.errors, :status => :unprocessable_entity }
      else 
        flash[:notice] = "#{@project_allocations.size} project allocations were successfully created."
        flash[:notice] += "I allocated projects as follows:<br />"
        @project_allocations.each do |pa|
          flash[:notice] += "Project #{pa.project_id} was allocated to student #{Student.find(pa.student_id).student_id}<br />"
        end
        format.html { redirect_to new_project_allocation_path }
        # This will not work!
        #format.xml  { render :xml => @project_allocation, :status => :created, :location => @project_allocation }
      end
    end
  end

  # PUT /project_allocations/1
  # PUT /project_allocations/1.xml
  def update
    @project_allocation = ProjectAllocation.find(params[:id])

    respond_to do |format|
      if @project_allocation.update_attributes(params[:project_allocation])
        flash[:notice] = 'Project allocation was successfully updated.'
        format.html { redirect_to(@project_allocation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_allocation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_allocations/1
  # DELETE /project_allocations/1.xml
  def destroy
    @project_allocation = ProjectAllocation.find(params[:id])
    @project_allocation.deallocate

    respond_to do |format|
      format.html { redirect_to(project_allocations_url) }
      format.xml  { head :ok }
    end
  end

  private

  def get_status
    @status = Status.find(1)
  end

  def can_allocate_projects?
    unless @status.can_allocate?
      flash[:notice] = "Project allocation is not enabled at this time."
      redirect_to :action => "index"
    end
  end
end
