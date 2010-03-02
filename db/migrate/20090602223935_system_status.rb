require 'active_record/fixtures'

class SystemStatus < ActiveRecord::Migration
  def self.up
    create_table "status_settings" do |t|
      t.integer  "code"
      t.string   "title"
      t.text     "message"
      # Default permissions for administrator, coordinator, staff, student, others
      # Modelled on Unix
      t.integer  "permissions", :integer, :default => 070000

      t.timestamps
    end

    # This is a plural though it's really only a singleton
    create_table "statuses", :force => true do |t|
      t.integer  "status_setting_id", :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
    drop_table :status_settings
  end
end
