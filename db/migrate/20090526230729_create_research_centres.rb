

class CreateResearchCentres < ActiveRecord::Migration
  def self.up
    create_table :research_centres do |t|
      t.string :abbrev
      t.string :title
      t.integer :coordinator

      t.timestamps
    end




  end

  def self.down
    drop_table :research_centres
  end
end
