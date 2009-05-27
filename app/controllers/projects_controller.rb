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


  skip_before_filter :login_required, :only => ["index","by_discipline","by_centre","by_supervisor"]
  require_role ["admin", "coordinator", "staff"], :for => ["new", "create", "edit", "update", "destroy"]


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

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end


  helper_method :can_edit

  # Non standard methods

  def allocate
    @projects = Project.find_by_sql "SELECT * FROM projects WHERE id NOT IN (SELECT project_id FROM students WHERE project_id IS NOT NULL)"
    @students = Student.find_by_sql "SELECT * FROM students WHERE project_id IS NULL OR project_id = 0 ORDER BY grade DESC"
    @assigned = []
    @ass_students = []
    @nass_students = []
    @students.each do |s|
      @applied = Student.find_by_sql "SELECT p.title, p.id AS project_id, sp.wish, CONCAT(s.first_name, ' ', s.last_name) AS fname, s.id AS student_id FROM projects AS p, users AS s, wishes AS sp WHERE  sp.project_id = p.id AND sp.student_id = s.id AND sp.student_id=#{s.id} ORDER BY sp.wish ASC"
      assigned = false
      @applied.each do |app|
        if !@assigned.include?(app.project_id) && !assigned
          @assigned.push(app.project_id)
          @ass_students.push(app.student_id)
          assigned = true
        end
      end
      unless assigned
        @nass_students.push(s.id)
      end
    end
    i = 0
    @assigned.each do |p|
      #@ass_students[i] = (Project.find p).title
      @student = Student.find(@ass_students[i])
      s = {}
      s[:student] = {}
      s[:student][:project_id] = p
      @student.attributes = s[:student]
      @student.save!
      i += 1
    end

    cs = Student.find_by_sql "SELECT MAX( tour ) AS mt FROM `students`WHERE project_id IS NOT NULL OR project_id != 0"
    @last_tour = cs[0].mt

    @nass_students.each do |nas|
      @student = Student.find(nas)
      s = {}
      s[:student] = {}
      s[:student][:tour] = @last_tour.to_i + 1
      @student.attributes = s[:student]
      @student.save!
    end


  end

  def my_projects
    # Need to have different results for staff and students
    if ! session[:user_id]
      flash[:notice] = "You need to be logged in to see your own projects!"
      redirect_to :action => "index"
    else
      @projects = Project.find(:all,
        :conditions => ["created_by = ?", session[:user_id]])
    end
  end

  def by_supervisor
    @projects = Project.find_by_sql "SELECT p.title, p.id, u.last_name FROM `projects` AS p, users AS u WHERE p.created_by = u.id ORDER BY u.last_name ASC"
  end

  def by_discipline
    @disciplines_projects = DisciplinesProjects.find(:all, :order =>'discipline_id')
  end

  def by_centre
    @projects = Project.find(:all)
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
