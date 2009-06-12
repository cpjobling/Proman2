require 'active_record/fixtures'

class MakeDevelUsers < ActiveRecord::Migration
  def self.up
  	down
  	
    # Creation of users depends on roles so migration moved to create role
  end

  def self.down
   	User.delete_all 
  end
end
