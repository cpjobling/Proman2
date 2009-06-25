class CreateProjectAllocations < ActiveRecord::Migration
  def self.up
    create_table :project_allocations do |t|
      t.integer :student_id, :null => false
      t.integer :project_id, :null => false
      t.integer :supervisor_id, :null => false
      t.integer :allocation_round, :null => false

      t.timestamps
    end
    add_index :project_allocations, :student_id
    add_index :project_allocations, :project_id
    add_index :project_allocations, :allocation_round
    add_index :project_allocations, :supervisor_id
  end

  def self.down
    remove_index :project_allocations, :student_id
    remove_index :project_allocations, :project_id
    remove_index :project_allocations, :allocation_round
    remove_index :project_allocations, :supervisor_id
    drop_table :project_allocations
  end
end
