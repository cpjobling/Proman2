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
  before_filter :can_select_projects
  before_filter :find_student_and_project_selection
  current_tab :project_selections

  # GET /project_selections
  # GET /project_selections.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_selection }
    end
  end

  # GET /project_selections/1
  # GET /project_selections/1.xml
  def show
    @selected_projects = @project_selection.selected_projects

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_selection }
    end
  end

  # GET /project_selections/new
  # GET /project_selections/new.xml
  def new
    @projects = projects_suitable_for_student
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_selection }
    end
  end
  
  # GET /project_selections/1/edit
  def edit
    # This should be projects for student's discipline
    @projects = projects_suitable_for_student
    @selected_projects = @project_selection.selected_projects
  end


  # POST /project_selections
  # POST /project_selections.xml
  def create
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
        flash[:notice] = 'Project selection was successfully updated.'
        format.html { redirect_to(project_selection_selected_projects_path(@project_selection)) }
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
    @project_selection.destroy

    respond_to do |format|
      format.html { redirect_to(project_selections_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_student_and_project_selection
    @student = current_user.student
    unless @student.project_selection
      # Haven't yet got a project-selection record
      @student.project_selection = ProjectSelection.create(:student => @student, :round => current_selection_round)
    end
    @project_selection = @student.project_selection
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

  def can_select_projects
    unless Proman::Config.can_select?
      flash[:notice] = "Project selection is not enabled at this time."
      redirect_to :controller => "projects", :action => "index"
    end
  end

  def current_selection_round
    return Proman::Config.current_selection_round
  end

  def projects_suitable_for_student
    d = Discipline.find(@student.discipline)
    return d.projects.find(:all)
  end
end
