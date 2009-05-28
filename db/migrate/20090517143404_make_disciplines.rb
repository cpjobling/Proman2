require 'active_record/fixtures'

class MakeDisciplines < ActiveRecord::Migration
  def self.up
  	down
  	
  	# Populate disciplines from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "disciplines")
  end

  def self.down
  	Discipline.delete_all
  end

end
