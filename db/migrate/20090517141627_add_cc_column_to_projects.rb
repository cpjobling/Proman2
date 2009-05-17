class AddCcColumnToProjects < ActiveRecord::Migration
  def self.up
  	add_column :projects, :carbon_critical, :boolean, :default => false
  end

  def self.down
  	remove_column :projects, :carbon_critical
  end
end
