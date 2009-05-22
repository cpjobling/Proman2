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
           # 0: title, 1: first, 2: initials, 3: last, 4: staff_id, 5: login
           user.id = row[4].to_i * 1000000 # staff number shifted 6 digits to left
                                           # to avoid clash with 6 digit student number
           user.login = row[5]

           title = row[0] || ""
           first_name = row[1] || ""
           initials = row[2] || ""
           last_name = row[3] || ""
           user_name = Name.new(first_name, last_name, title, initials, "")
           
           user.name = user_name
           user.password = 'swansea' + row[4]
           user.password_confirmation = 'swansea' + row[4]
           user.email = row[5] + '@swansea.ac.uk' # login@swansea.ac.uk
           user.add_role(staff_role)
           if user.save
           	 logger.info "#{n}: Added #{user_name} as #{user.id}<br />\n"
             n = n+1
             GC.start if n % 50 == 0
           else
              logger.error "Couldn't save record for #{user.name}"
            end
           flash[:notice] = "#{result}\nCSV Staff Import Successful,  #{n} new records added to data base."
      end
      redirect_to admin_users_path
   end
end
