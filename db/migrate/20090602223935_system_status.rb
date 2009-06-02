require 'active_record/fixtures'

class SystemStatus < ActiveRecord::Migration
  def self.up
    create_table :system_status do |t|
      t.integer :code
      t.string :status
      t.text :message

      t.timestamps
    end
    # Populate research centres from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "system_status")
  end

  def self.down
    drop_table :system_status
  end
end
