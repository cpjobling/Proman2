class AddNotNullsToResearchCentre < ActiveRecord::Migration
  def self.up
    change_column :research_centres, :title, :string, :null => :false
    change_column :research_centres, :abbrev, :string, :limit=> 10,  :null => :false
  end

  def self.down
    change_column :research_centres, :title, :string
    change_column :research_centres, :abbrev, :string
  end
end
