class RenameCreatedByToSupervisorId < ActiveRecord::Migration
  def self.up
    rename_column :projects, :created_by, :supervisor_id
  end

  def self.down
    rename_column :projects, :supervisor_id, :created_by
  end
end
