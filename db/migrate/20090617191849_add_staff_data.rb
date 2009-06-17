require 'active_record/fixtures'

class AddStaffData < ActiveRecord::Migration
  def self.up

    # Create users from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "users")
  	# Create initial supervisors from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "original_supervisors")
    
  end

  def self.down
    OriginalSupervisor.delete_all
  end
end
