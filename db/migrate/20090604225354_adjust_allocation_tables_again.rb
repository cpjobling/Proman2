class AdjustAllocationTablesAgain < ActiveRecord::Migration
  def self.up
    remove_column :project_selections, :selected_project_id
    drop_table :project_selections_selected_projects
  end

  def self.down
    add_column :project_selections, :selected_project_id, :integer

    # ProjectSelection has and belongs to many SelectedProject
    create_table :project_selections_selected_projects, :id => false do |t|
      t.integer :project_selection_id
      t.integer :selected_project_id
    end
  end
end
