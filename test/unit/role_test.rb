require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  def test_admin_role_exists
    admin_role = Role.find_by_name('admin')
    assert_not_nil admin_role, "There needs to be an admin role" 
  end
  
  def test_key_roles_exist
  	['student', 'staff', 'coordinator'].each do |role|
  		assert_not_nil role, "Role #{role} is needed for this application to work"
  	end
  end
end
