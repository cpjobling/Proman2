class CreateProjectAllocations < ActiveRecord::Migration
  def self.up
    create_table :project_allocations do |t|
      t.integer :user_id
      t.integer :student_id
      t.integer :project_id
      t.integer :allocation_round

      t.timestamps
    end
  end

  def self.down
    drop_table :project_allocations
  end
end
