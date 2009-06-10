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

class SelectedProjectsController < ApplicationController
  require_role "student"
  current_tab :project_selections
  before_filter :find_student_and_project_selection
  before_filter :verify_ownership

  def index
    @selected_projects = @project_selection.selected_projects

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @selected_projects }
    end
  end

  def show
    @selected_project = @project_selection.selected_projects.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @selected_project }
    end
  end

  def edit
    @selected_project = @project_selection.selected_projects.find(params[:id])
  end

  def update
    @selected_project = @project_selection.selected_projects.find(params[:id])
    sp = params[:selected_project]
    new_position = sp['position'].to_i
    @selected_project.insert_at(new_position)
    @project_selection.selected_projects(true) # Force reload
    respond_to do |format|
      if @selected_project.save
        flash[:notice] = 'Project successfully re-ranked'
        format.html { redirect_to([@project_selection, @selected_project]) }
        format.xml { head :ok }
      else
        format.html { reder :action => "edit" }
        format.xml { render :xml => @selected_project.errors,
          :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @selected_project = @project_selection.selected_projects.find(params[:id])
    @selected_project.destroy

    respond_to do |format|
      format.html { redirect_to project_selection_selected_projects_url(@project_selection)}
      format.xml { head :ok }
    end
  end
  # Other CRUD actions
  
  private

  
  def find_student_and_project_selection
    @student = current_user.student
    @project_selection = ProjectSelection.find(params[:project_selection_id])
  end

  def verify_ownership
    unless @project_selection.student == @student
      flash[:notice] = "You are not permitted to access another student's selected projects. This access attempt has been logged."
      logger.error "Student #{@student.id} attempted to access project selection id #{@project_selection.id} at #{Time.now}"
      redirect_to project_selections_url
    end
  end

end
