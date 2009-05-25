class CreateStudentsAndProjectAllocations < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      
      t.integer :user_id
      t.decimal :grade, :precision=>10, :scale=>2
      t.integer :project_selection_id
      t.integer :project_allocation_id
      t.integer :discipline_id
      t.timestamps
    end

    create_table :project_allocations do |t|
      t.integer :project_id
      t.integer :student_id

      t.timestamps
    end

    create_table :project_selections do |t|
      t.integer :project_id
      t.integer :student_id
      t.integer :position # for acts_as_list

      t.timestamps
    end


  end

  def self.down
    drop_table :students
    drop_table :project_selections
    drop_table :project_allocations
  end
end
