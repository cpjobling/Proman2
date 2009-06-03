class AddRoundToProjectSelections < ActiveRecord::Migration
  def self.up
    add_column :project_selections, :round, :integer
  end

  def self.down
    remove_index :project_selections, :round
    remove_column :project_selections, :round
  end
end
