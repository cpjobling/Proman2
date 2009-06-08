

class RecreateStatusRecord < ActiveRecord::Migration
  def self.up
    drop_table :status
    # This is a plural though it's really only a singleton
    create_table :statuses do |t|
      t.integer :status_setting_id

      t.timestamps
    end
    # drop and then recreate status_id column so that it can have intial value 1
    remove_column :status_settings, :status
    add_column :status_settings, :status_id, :integer, :default => 1

    status = Status.new(:id => 1)
    default_setting = StatusSetting.find_by_code(100)
    status.status_setting = default_setting
    status.save!


    # Now add owner to all existing status settings
    settings = StatusSetting.find(:all)
    settings.each do |s|
      s.status = status
      s.save!
    end
  end

  def self.down
    remove_column :status_settings, :status_id
    add_column :status_settings, :status, :string
    drop_table :statuses
    create_table :status do |t|
      t.integer :system_status_id
    end
  end
end
