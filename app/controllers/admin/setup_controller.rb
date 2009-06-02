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
class Admin::SetupController < ApplicationController

	# a controller for bulk uploading of staff, students and projects
	# Based on "How to import CSV file in rails", http://satishonrails.wordpress.com/2007/07/18/how-to-import-csv-file-in-rails/
	
	
  require 'csv'
  require 'logger'

  current_tab :admin
	require_role "admin"
  
  def index
    
  end
  
  def import_staff
   	
  end

  def csv_import_staff
    staff_role = Role.find_by_name('staff')
    @parsed_file = CSV::Reader.parse(params[:import_staff][:staff_file])
    n=0
    result = ""
    @parsed_file.each  do |row|
      user = User.new
      logger.info "Read: #{row}"
      # 0: title, 1: first, 2: initials, 3: last, 4: staff_id, 5: login, 6: centre
      # to avoid clash with 6 digit student number
      user.login = row[5]

      title = row[0] || ""
      first_name = row[1] || ""
      initials = row[2] || ""
      last_name = row[3] || ""
      user_name = Name.new(title, first_name, last_name, initials, "")
           
      user.name = user_name
      user.password = 'swansea' + row[4]
      user.password_confirmation = 'swansea' + row[4]
      user.email = row[5] + '@swansea.ac.uk' # login@swansea.ac.uk
      user.add_role(staff_role)
      if user.save
        logger.info "#{n}: Added #{user_name} as #{user.id}<br />\n"
        supervisor = Supervisor.new(:staff_id => row[4])
        supervisor.research_centre = ResearchCentre.find_by_abbrev(row[6])
        supervisor.user = user
        supervisor.save
        logger.info "User #{user.id} with staff id #{supervisor.staff_id} added as supervisor #{supervisor.id}"
        logger.info "Staff member #{supervisor.staff_id} has been assigned to #{supervisor.research_centre.title}"
        n = n+1
        GC.start if n % 50 == 0
      else
        logger.error "Couldn't save record for #{user.name}"
      end
      flash[:notice] = "#{result}\nCSV Staff Import Successful,  #{n} new records added to data base."
    end
    redirect_to admin_users_path
  end

  def import_students
  end

  def csv_import_students
    student_role = Role.find_by_name('student')
    @parsed_file = CSV::Reader.parse(params[:import_students][:students_file])
    n=0
    result = ""
    @parsed_file.each  do |row|
      user = User.new
      logger.info "Read: #{row}"
      # 0: Discipline; 1: Number; 2: Title; 3: Surname; 4: First name; 5: Initials: 6; DOB; 7: Email
      # user.id = row[1].to_i # student number
      # to avoid clash with 6 digit student number
      user.login = row[1]

      title = row[2] || ""
      first_name = row[4] || ""
      initials = row[5] || ""
      last_name = row[3] || ""
      user_name = Name.new(title, first_name, last_name, initials, "")

      user.name = user_name
      user.password = row[6]
      user.password_confirmation = row[6]
      user.email = row[7]
      user.add_role(student_role)
      if user.save
        logger.info "#{n}: Added #{user_name} as #{user.id}<br />\n"
        n = n+1
        student = Student.new(:student_id => row[1])
        student.discipline = Discipline.find_by_name(row[0])
        student.user = user
        student.save
        logger.info "User #{user.id} added as student #{student.student_id} with discipline #{student.discipline.long_name}"
        GC.start if n % 50 == 0
      else
        logger.error "Couldn't save record for #{user.name}"
      end
      flash[:notice] = "#{result}\nCSV student Import Successful,  #{n} new records added to data base."
    end
    redirect_to admin_students_path
  end

  def import_projects

  end

  def csv_import_projects
    @parsed_file = CSV::Reader.parse(params[:import_projects][:projects_file])
    n=0
    result = ""
    @parsed_file.each  do |row|
      project = Project.new
      logger.info "Read: #{row}"
      "0: Centre	1: Supervisor	2: Email	3: Title	4: Description	5: Resources	6: Suitable for"
      email = row[2].downcase
      supervisor = User.find(:first, :conditions => ['email LIKE ?', email])
      if supervisor
        logger.info "Found user #{supervisor} to match #{email}"
        project.user = supervisor
      else
        logger.info "Couldn't find user #{supervisor} to match #{email}"
      end
      
      project.title = row[3]
      project.description = row[4]
      project.resources = row[5] || ""
      suited_to = row - row[0..5]
      logger.info "Found disciplines for #{suited_to}"
      if suited_to[0].downcase == "all"
        logger.info "Project is suitable for all"
        project.suitable_for_all
      else
        project.suitable_for_these(suited_to)
      end
      if project.save
        logger.info "#{n}: Added #{project.title} as #{project.id}<br />\n"
        n = n+1
        GC.start if n % 50 == 0
      else
        logger.error "Couldn't save record for #{project.title}"
      end
      flash[:notice] = "#{result}\nCSV Projects Import Successful,  #{n} new records added to data base."
    end
    redirect_to admin_projects_path
    end
  end  
