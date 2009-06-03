class AddIndicesToProjectSelectionTables < ActiveRecord::Migration
  def self.up
    add_index :project_selections_selected_projects, :project_selection_id
    add_index :project_selections_selected_projects, :selected_project_id
  end

  def self.down
    remove_index :project_selections_selected_projects, :project_selection_id
    remove_index :project_selections_selected_projects, :selected_project_id
  end
end
