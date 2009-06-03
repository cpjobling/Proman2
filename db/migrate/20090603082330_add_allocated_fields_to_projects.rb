class AddAllocatedFieldsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :allocated, :boolean, :default => false
    add_column :projects, :round, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :allocated
    remove_column :projects, :round
  end
end
