class AddStudentToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :student_id, :integer
    # Project would be available for selection if there is no student allocated or if the project was withdrawn
    add_column :projects, :available, :boolean, :default => true
  end

  def self.down
    remove_column :projects, :student_id, :integer
    remove_column :projects, :round, :integer
    remove_column :available, :boolean, :default => true
  end
end
