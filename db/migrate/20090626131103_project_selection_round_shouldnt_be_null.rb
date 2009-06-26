class ProjectSelectionRoundShouldntBeNull < ActiveRecord::Migration
  def self.up
    change_column :project_selections, :round, :integer, :default => 1
  end

  def self.down
    change_column :project_selections, :round, :integer
  end
end
