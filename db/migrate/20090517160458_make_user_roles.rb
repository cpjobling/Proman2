require 'active_record/fixtures'

class MakeUserRoles < ActiveRecord::Migration
  def self.up

    # Create roles from fixture ... see dev_data/README.txt
    directory = File.join(File.dirname(__FILE__), '../../test/fixtures')
    Fixtures.create_fixtures(directory, "roles")
    
    # Create users from fixture ... see dev_data/README.txt
    Fixtures.create_fixtures(directory, "users")

    # Create user-roles from fixture
    Fixtures.create_fixtures(directory, "roles_users")
  end

  def self.down
  end
end
