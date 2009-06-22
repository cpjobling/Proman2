require 'active_record/fixtures'

class AddSettingsForCanAllocateAndCanSelectToStatusSettings < ActiveRecord::Migration
  def self.up
    # Populate status_settings and status from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "status_settings")
    Fixtures.create_fixtures(directory, "statuses")
  end
  def self.down
  end
end
