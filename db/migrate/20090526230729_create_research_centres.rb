require 'active_record/fixtures'

class CreateResearchCentres < ActiveRecord::Migration
  def self.up
    create_table :research_centres do |t|
      t.string :abbrev
      t.string :title
      t.integer :coordinator

      t.timestamps
    end
    # Populate research centres from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "research_centres")

  end

  def self.down
    drop_table :research_centres
  end
end
