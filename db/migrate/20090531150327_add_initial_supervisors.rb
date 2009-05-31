require 'active_record/fixtures'

class AddInitialSupervisors < ActiveRecord::Migration
  def self.up
    # Create initial supervisors from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "supervisors")
  end

  def self.down
  end
end
