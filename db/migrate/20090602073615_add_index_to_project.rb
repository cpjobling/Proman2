class AddIndexToProject < ActiveRecord::Migration
  def self.up
    add_index :projects, :created_by
  end

  def self.down
    remove_index :projects, :created_by
  end
end
