class AddSureFieldToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :sure, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :sure
  end
end
