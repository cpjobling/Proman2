class AdjustAllocationTables < ActiveRecord::Migration
  def self.up
    rename_column :students, :project_allocation_id, :project_id
    drop_table :project_allocations
    remove_column :project_selections, :position

    # Child table for ProjectSelection: needed for acts_as_list
    create_table :selected_projects do |t|
      t.integer :project_selection_id
      t.integer :position
      t.integer :project_id
    end

    remove_column :project_selections, :project_id
    add_column :project_selections, :selected_project_id, :integer

    # ProjectSelection has and belongs to many SelectedProject
    create_table :project_selections_selected_projects, :id => false do |t|
      t.integer :project_selection_id
      t.integer :selected_project_id
    end
  end

  def self.down
    drop_table :project_selections_selected_projects
    remove_column :project_selections, :selected_project_id
    add_column :project_selections, :project_id, :integer
    drop_table :selected_projects
    add_column :project_selections, :position, :integer
    create_table :project_allocations do |t|
      t.integer :project_id
      t.integer :student_id

      t.timestamps
    end
    rename_column :students, :project_id, :project_allocation_id
  end
end
