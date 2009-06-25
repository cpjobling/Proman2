class RemoveRedundantRecordsFromProject < ActiveRecord::Migration
  def self.up
    remove_column :projects, :student_id
    remove_column :projects, :round
  end

  def self.down
    add_column :projects, :student_id, :integer
    add_column :projects, :round, :integer, :default => 0
  end
end
