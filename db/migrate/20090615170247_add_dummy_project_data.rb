require 'active_record/fixtures'

class AddDummyProjectData < ActiveRecord::Migration
  def self.up
    # Populate status_settings and status from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "projects")
  end

  def self.down
  end
end
