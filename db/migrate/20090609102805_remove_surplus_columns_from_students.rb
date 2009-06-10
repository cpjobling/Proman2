class RemoveSurplusColumnsFromStudents < ActiveRecord::Migration
  def self.up
    remove_column :students, :project_selection_id
    remove_column :students, :project_id
  end

  def self.down
    add_column :students, :project_selection_id, :integer
    add_column :students, :project_id, :integer
  end
end
