class MakeSomeProjects < ActiveRecord::Migration
  def self.up

    # Create projects from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "projects")
    Fixtures.create_fixtures(directory, "disciplines_projects")
  end

  def self.down
    Project.delete_all
  end
end
