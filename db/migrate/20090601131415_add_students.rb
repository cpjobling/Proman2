require 'active_record/fixtures'

class AddStudents < ActiveRecord::Migration
  def self.up
    # Create initial supervisors from fixture ... see dev_data/README.txt
    #irectory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    #Fixtures.create_fixtures(directory, "students")
  end

  def self.down

  end
end
