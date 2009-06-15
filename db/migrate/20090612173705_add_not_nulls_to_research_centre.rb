class AddNotNullsToResearchCentre < ActiveRecord::Migration
  def self.up
    change_column :research_centres, :title, :string, :null => :false
    change_column :research_centres, :abbrev, :string, :limit=> 10,  :null => :false
    change_column :research_centres, :coordinator, :integer, :null => :false
  end

  def self.down
    change_column :research_centres, :coordinator, :integer
    change_column :research_centres, :title, :string
    change_column :research_centres, :abbrev, :string
  end
end
