class CreateSupervisors < ActiveRecord::Migration
  def self.up
    create_table :supervisors do |t|
      t.integer :research_centre_id
      t.integer :user_id

      t.timestamps
    end

    create_table :supervisors_projects do |t|
      t.integer :supervisor_id
      t.integer :project_id
    end
    add_index "supervisors_projects", "supervisor_id"
    add_index "supervisors_projects", "project_id"
  end

  def self.down
    drop_table :supervisors_projects
    drop_table :supervisors
  end
end
