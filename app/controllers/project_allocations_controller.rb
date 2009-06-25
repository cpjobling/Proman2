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
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_allocation }
    end
  end

  # GET /project_allocations/1/edit
  def edit
    @project_allocation = ProjectAllocation.find(params[:id])
    @allocation_round = @status.selection_round
  end

  # POST /project_allocations
  # POST /project_allocations.xml
  def create
    @project_allocation = ProjectAllocation.new(params[:project_allocation])

    respond_to do |format|
      if @project_allocation.save
        flash[:notice] = 'Project allocation was successfully created.'
        format.html { redirect_to(@project_allocation) }
        format.xml  { render :xml => @project_allocation, :status => :created, :location => @project_allocation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_allocation.errors, :status => :unprocessable_entity }
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
    @project_allocation.destroy

    respond_to do |format|
      format.html { redirect_to(project_allocations_url) }
      format.xml  { head :ok }
    end
  end

  # GET /project_allocations/selections
  def selections
    @project_selections = ProjectSelection.all
    @allocation_round = @status.selection_round
  end

  # POST /project_allocations/updates
  # POST /project_allocations/updates
  def updates
    # TODO: process one or more project allocations
    # like create ... but for a list of student/projects

    respond_to do |format|
      if @project_allocation.save
        flash[:notice] = '[n] project allocation were successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @project_allocation, :status => :created, :location => @project_allocation }
      else
        format.html { render :action => "selections" }
        format.xml  { render :xml => @project_allocation.errors, :status => :unprocessable_entity }
      end
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
