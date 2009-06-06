class AddPermissionsToStatus < ActiveRecord::Migration
  def self.up
    rename_table :system_status, :status_settings
    # Default permissions for administrator, coordinator, staff, student, others
    # Modelled on Unix
    add_column :status_settings, :permissions, :integer, :default => 070000 #
    statuses = {100 => 070000,
                200 => 076600,
                201 => 076640,
                202 => 076640,
                203 => 076460,
                204 => 076440,
                205 => 076460,
                206 => 076440,
                207 => 076460,
                208 => 076440,
                300 => 076440 }
    statuses.each do |code,permissions|
      s = StatusSetting.find_by_code(code)
      s.permissions = permissions
      s.save!
    end
  end

  def self.down
    rename_table :status_settings, :system_status
    remove_column :system_status, :permissions
  end
end
