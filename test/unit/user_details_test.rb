require File.dirname(__FILE__) + '/../test_helper'

class UserDetailsTest < ActiveSupport::TestCase
  # Tests the basic function of the user classes ...
  # see user_test.rb for tests of restful authentication functionality
  fixtures :users, :roles

  def setup()
    @name = Name.new("Jools", "Holland", "Mr", "H.", "Jack")
  end
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_invalid_with_empty_atributes
  	user = User.new
  	assert !user.valid?
  	assert user.errors.invalid?(:login)
  	assert user.errors.invalid?(:email)
  end

  def test_unique_login
  	user = User.new(:login => users(:academic).login,
  		:email => "academic@xyz.com",
  		:name => @name,
  		#:staff_or_student_number => "777777",
  		:password => "test",
  		:password_confirmation => "test")

  	assert !user.save
  end

  test "test invalid password has less than 6 characters" do
    ["a", "ab", "abc", "abcd", "abcde", "abcdef"].each do |password|
      user = User.new(:login => "newuser" + password,
        :email => "academic#{password}@xyz.com",
        :name => @name,
        #:staff_or_student_number => "777777",
        :password => "test",
        :password_confirmation => "test")

      assert !user.save
    end
  end

  test "test valid password must be longer than 6 characters" do
    user = User.new(:login => "newuser",
      :email => "academic@xyz.com",
      :name => @name,
      #:staff_or_student_number => "777777",
      :password => "test123",
      :password_confirmation => "test123")

    assert user.save
  end

  test "test password must be no longer than 40 characters" do
    user = User.new(:login => "newuser1",
      :email => "academic1@xyz.com",
      :name => @name,
      #:staff_or_student_number => "777777",
      :password => "0123456789112345678921234567893123456789",
      :password_confirmation => "0123456789112345678921234567893123456789")

    assert user.save, "Password has 40 characters"

    user = User.new(:login => "newuser2",
      :email => "academic2@xyz.com",

      #:staff_or_student_number => "777777",
      :password => "01234567891123456789212345678931234567894",
      :password_confirmation => "01234567891123456789212345678931234567894")

    assert !user.save, "Password has more than 40 characters"
  end

  def test_unique_email
    user = User.new(:login => "newuser",
      :email => users(:student).email,
      :name => @name,
      :staff_or_student_number => "777777",
      :password => "testing123",
      :password_confirmation => "testing123")

    assert !user.save, "should not validate"
  end

  #  def test_unique_staff_or_student_number
  #  	user = User.new(:login => "newuser",
  #  		:email => users(:student).email,
  #  		:first_name => "Lillian",
  #  		:last_name => "Gish",
  #  		:staff_or_student_number =>
  #  		         users(:coordinator).staff_or_student_number,
  #  		:password => "test",
  #  		:password_confirmation => "test")
  #
  #  	assert !user.save
  #  	assert_equal "has already been taken",
  #  	        user.errors.on(:staff_or_student_number)
  #  end

  def test_new_user_has_no_role_assigned
    guest = users(:student)

    roles = Role.find(:all)
    roles.each do |role|
      assert !guest.has_role?(role), "Should not have role #{role.to_s}"
    end
  end

  def test_new_user_is_not_admin
    guest = users(:academic)
    assert !guest.has_role?('admin'), "Guest user shouldn't have admin role"
  end

  def test_admin_user_has_admin_role
    admin = users(:admin)
    assert admin.has_role?('admin'), "admin user should have the 'admin' role"
  end

  def test_student_user_should_have_student_role
    user = users(:student)
    assert user.has_role?('student'), "user should have student role"
  end

  def test_academic_user_should_have_staff_role
    user = users(:academic)
    assert user.has_role?('staff'), "user should have staff role"
  end

  def test_coordinator_user_should_have_staff_and_coordinator_roles
    user = users(:coordinator)
    assert user.has_role?('coordinator'),
      "user should have coordinator role"
    assert user.has_role?('staff'), "user should have staff role"
  end



  def test_add_role
    user = User.create(:login => "newuser",
      :email => "newuser@xyz.com",
      :name => @name,
      #:staff_or_student_number => "777777",
      :password => "testing123",
      :password_confirmation => "testing123")

    roles = Role.find(:all)
    roles.each do |role|
      unless role.name == "admin" # admin user has all roles
        assert !user.has_role?(role.name),
          "Shouldn't yet have role #{role.name}"
        user.add_role(role)
        assert user.has_role?(role.name),
          "Should now have role #{role.name}"
      end
    end
  end

  test "Admin user has all roles" do
    user = users(:admin)
    roles = Role.find(:all)
    roles.each do |role|
      assert user.has_role?(role), "admin user should have role #{role.name}"
    end
  end

end
