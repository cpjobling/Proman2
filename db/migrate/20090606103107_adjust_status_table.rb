class AdjustStatusTable < ActiveRecord::Migration
  def self.up
    rename_table :system_status, :status_settings
    # Default permissions for administrator, coordinator, staff, student, others
    # Modelled on Unix
    add_column :status_settings, :permissions, :integer, :default => 070000 #
  end

  def self.down
    rename_table :status_settings, :system_status
    remove_column :system_status, :permissions
  end
end
