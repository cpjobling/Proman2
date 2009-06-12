require 'active_record/fixtures'

class AddCoordinatorsToResearchCentres < ActiveRecord::Migration
  def self.up
     rename_column :research_centres, :coordinator, :supervisor_id

    # Populate research centres from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "research_centres")
  end

  def self.down
    rename_column :research_centres, :supervisor_id, :coordinator
  end
end
