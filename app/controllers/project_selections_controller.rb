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
#

class ProjectSelectionsController < ApplicationController

  require_role "student"
  before_filter :find_student
  current_tab :project_selections

  # GET /project_selections
  # GET /project_selections.xml
  def index
    @project_selection = @student.project_selection

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_selection }
    end
  end

  # GET /project_selections/1
  # GET /project_selections/1.xml
  def show
    @project_selection = ProjectSelection.find(params[:id])
    @selected_projects = @project_selection.selected_projects

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_selection }
    end
  end

  # GET /project_selections/new
  # GET /project_selections/new.xml
  def new
    @project_selection = ProjectSelection.new
    @project_selection.student = @student
    @projects = Project.find(:all)
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_selection }
    end
  end
  
  # GET /project_selections/1/edit
  def edit
    @project_selection = ProjectSelection.find(params[:id])
    @selected_projects = {}
    Project.find(:all).collect {|p| @projects[p.title] = p.id }
  end


  # POST /project_selections
  # POST /project_selections.xml
  def create
    unless @project_selection = ProjectSelection.find_by_student_id(@student.id)
      @project_selection = ProjectSelection.create(:student => @student)
    end
    if project_selection = params[:project_selection]
      if project_selection['project_ids']
        unless @project_selection.selected_projects.empty?
          @project_selection.selected_projects.clear
        end
        selected_projects = project_selection['project_ids'].map {|id| Project.find(id)}
        for project in selected_projects
          @project_selection.selected_projects.create(:project => project)
        end
      end
    end

    respond_to do |format|
      if @project_selection.save
        flash[:notice] = 'ProjectSelection was successfully created.'
        format.html { redirect_to(project_selection_selected_projects_path(@project_selection)) }
        format.xml  { render :xml => @project_selection, :status => :created, :location => @project_selection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_selection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_selections/1
  # PUT /project_selections/1.xml
  def update
    @project_selection = ProjectSelection.find(params[:id])
    project_selection = params[:project_selection]
    selected_projects = project_selection[:selected_projects]
    selected_projects.each do |sp|
      p = Project.find(sp.to_i)
      @project_selection.selected_projects.create(:project => p)
    end
    respond_to do |format|
      if @project_selection.save
        flash[:notice] = 'Project selection was successfully updated.'
        format.html { redirect_to(@project_selection) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_selection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_selections/1
  # DELETE /project_selections/1.xml
  def destroy
    @project_selection = ProjectSelection.find(params[:id])
    @project_selection.destroy

    respond_to do |format|
      format.html { redirect_to(project_selections_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_student
    @student = current_user.student
    puts @student
  end

  def handle_selected_projects(my_hash)
    if my_hash['project_ids']
      @project_selection.selected_projects.clear
      selected_projects = hash['project_ids'].map {|id| Project.find(id)}
      for project in selected_projects
        @project_selection.selected_projects.create(:project => project)
      end
    end
  end
end
