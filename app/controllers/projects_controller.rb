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

class ProjectsController < ApplicationController


  skip_before_filter :login_required

  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end


  def by_supervisor
    @supervisors = User.find(:all, :joins => :supervisor, :order => 'last_name, first_name')
  end

  def by_discipline
    @disciplines = Discipline.find(:all, :order => 'long_name')
  end

  def by_centre
    @centres = ResearchCentre.find(:all)
    @projects = Project.find(:all)
  end

  def specials
    @sure_projects = Project.find_all_by_sure(true)
    @c2_projects = Project.find_all_by_carbon_critical(true)
  end

  private

  def handle_disciplines_projects
    if params['discipline_ids']
      @project.disciplines.clear
      disciplines = params['discipline_ids'].map { |id| Discipline.find(id) }
      @project.disciplines << disciplines
    end
  end

  def collect_disciplines
    @disciplines = {}
    Discipline.find(:all).collect {|r| @disciplines[r.long_name] = r.id }
  end



end
