class AddRoundTable < ActiveRecord::Migration
  def self.up
    create_table :allocation_round, :id => false do |t|
      t.integer :round, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :allocation_round
  end
end
