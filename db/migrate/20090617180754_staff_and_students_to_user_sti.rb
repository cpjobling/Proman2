class StaffAndStudentsToUserSti < ActiveRecord::Migration
  def self.up
  	
  	rename_table :supervisors, :original_supervisors
  	rename_table :students,    :original_students

    # For STI
    add_column :users, :type, :string

    # Student fields
    add_column :users, :grade, :decimal, :precision => 10, :scale => 2
    add_column :users, :discipline_id, :integer
    add_column :users, :student_number, :string, :length=>8

    # Supervisor fields
    add_column :users, :research_centre_id, :integer
    add_column :users, :staff_number, :string, :length=>8
    add_column :users, :loading, :integer, :default => 4
    
    add_index :users, :staff_number
    add_index :users, :student_number
  end

  def self.down
  	
  	remove_index :users, :staff_number
  	remove_index :users, :student_number
  	
    # For STI
    remove_column :users, :type

    # Student fields
    remove_column  :users, :grade
    remove_column :users, :discipline_id
    remove_column :users, :student_number

    # Supervisor fields
    remove_column :users, :research_centre_id
    remove_column :users, :staff_number
    remove_column :users, :loading

    rename_table :original_supervisors, :supervisors
    rename_table :original_students, :students
  end
end
