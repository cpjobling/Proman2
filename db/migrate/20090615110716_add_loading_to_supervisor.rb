class AddLoadingToSupervisor < ActiveRecord::Migration
  def self.up
    add_column :supervisors, :loading, :integer, :default=>4
  end

  def self.down
    remove_column :supervisors, :loading
  end
end
