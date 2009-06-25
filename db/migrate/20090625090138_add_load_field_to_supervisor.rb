class AddLoadFieldToSupervisor < ActiveRecord::Migration
  def self.up
    add_column :supervisors, :load, :integer, :default => 0
  end

  def self.down
    remove_column :supervisors, :load
  end
end
