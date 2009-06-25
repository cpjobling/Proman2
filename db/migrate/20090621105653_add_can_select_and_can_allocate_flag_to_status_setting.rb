class AddCanSelectAndCanAllocateFlagToStatusSetting < ActiveRecord::Migration
  def self.up
    add_column :status_settings, :can_select, :boolean, :default=>false
    add_column :status_settings, :can_allocate, :boolean, :default=>false
    add_column :status_settings, :selection_round, :integer, :default => 0
    remove_column :status_settings, :integer
  end

  def self.down
    add_column :status_settings, :integer, :integer, :default=>070000
    remove_column :status_settings, :can_select
    remove_column :status_settings, :can_allocate
    remove_column :status_settings, :selection_round
  end
end
