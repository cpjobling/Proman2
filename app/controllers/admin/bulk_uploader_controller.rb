class Admin::BulkUploaderController < ApplicationController

	# a controller for bulk uploading of staff, students and projects
	# Based on "How to import CSV file in rails", http://satishonrails.wordpress.com/2007/07/18/how-to-import-csv-file-in-rails/
	
	
   require 'csv'
   require 'logger'
   
   def import_staff
   	
   end

   def csv_import_staff
   	   logger = Logger.new STDOUT 
   	   staff_role = Role.find_by_name('staff')
       @parsed_file = CSV::Reader.parse(params[:import_staff][:staff_file])
       n=0
       result = ""
       @parsed_file.each  do |row|
           user = User.new
           logger.info "Read: #{row}"
           user.id = row[0].to_i
           user.login = row[6] # same as email
           user_name = Name.new(row[1], row[2], row[3], row[4], "")
           user.name = user_name
           user.password = 'swansea' + row[5]
           user.password_confirmation = 'swansea' + row[5]
           user.email = row[6]
           user.add_role(staff_role)
           if user.save
           	result = result + "#{n}: Added #{user_name} as #{user.id}\n"
             n = n+1
             GC.start if n % 50 == 0
           end
           flash[:notice] = "#{result}\nCSV Staff Import Successful,  #{n} new records added to data base."
      end
      redirect_to '/'
   end
end
