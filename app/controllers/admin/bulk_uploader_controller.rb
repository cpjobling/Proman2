class Admin::BulkUploaderController < ApplicationController

	# a controller for bulk uploading of staff, students and projects
	# Based on "How to import CSV file in rails", http://satishonrails.wordpress.com/2007/07/18/how-to-import-csv-file-in-rails/
	
	
  require 'csv'
  require 'logger'
   
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
      user.id = row[4].to_i * 1000000 # staff number shifted 6 digits to left
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
      # TODO: create supervisor record
      if user.save
        logger.info "#{n}: Added #{user_name} as #{user.id}<br />\n"
        supervisor = Supervisor.new(:user_id => user.id)
        supervisor.research_centre = ResearchCentre.find_by_abbrev(row[6])
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
      user.id = row[1].to_i # student number
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
        student = Student.new(:user_id => user.id)
        student.discipline = Discipline.find_by_name(row[0])
        student.save
        GC.start if n % 50 == 0
      else
        logger.error "Couldn't save record for #{user.name}"
      end
      flash[:notice] = "#{result}\nCSV student Import Successful,  #{n} new records added to data base."
    end
    redirect_to admin_students_path
  end

end
