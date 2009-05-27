class CreateSupervisors < ActiveRecord::Migration
  def self.up
    create_table :supervisors do |t|
      t.integer :research_centre_id
      t.integer :user_id

      t.timestamps
    end

    create_table :projects_supervisors, :id => false do |t|
      t.integer :supervisor_id
      t.integer :project_id
    end
    add_index "projects_supervisors", "supervisor_id"
    add_index "projects_supervisors", "project_id"
  end

  def self.down
    drop_table :projects_supervisors
    drop_table :supervisors
  end
end
