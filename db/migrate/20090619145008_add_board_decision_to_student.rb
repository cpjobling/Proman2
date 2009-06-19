class AddBoardDecisionToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :board_decision, :string
  end

  def self.down
    remove_column :students, :board_decision
  end
end
