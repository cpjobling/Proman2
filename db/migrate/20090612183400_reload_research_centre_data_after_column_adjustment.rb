require 'active_record/fixtures'

class ReloadResearchCentreDataAfterColumnAdjustment < ActiveRecord::Migration
  def self.up
    # Populate research centres from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "research_centres")
  end

  def self.down
  end
end
