class CreateProjectAllocations < ActiveRecord::Migration
  def self.up
    create_table :project_allocations do |t|
      t.integer :user_id, :null => false
      t.integer :student_id, :null => false
      t.integer :project_id, :null => false
      t.integer :allocation_round, :null => false

      t.timestamps
    end
    add_index :project_allocations, [:student_id, :project_id, :allocation_round], :unique => :true
    add_index :project_allocations, :student_id
    add_index :project_allocations, :project_id
    add_index :project_allocations, :allocation_round
  end

  def self.down
    remove_index :project_allocations, [:student_id, :project_id, :allocation_round]
    remove_index :project_allocations, :student_id
    remove_index :project_allocations, :project_id
    remove_index :project_allocations, :allocation_round
    drop_table :project_allocations
  end
end
