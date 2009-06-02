class Status < ActiveRecord::Migration
  def self.up
    create_table :status do |t|
      t.integer :system_status_id
    end
  end

  def self.down
    drop_table :status
  end
end
