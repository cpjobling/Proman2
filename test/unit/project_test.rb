require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  fixtures :users, :projects

  def setup
    @project = projects(:project1)
    @disciplines = Discipline.find(:all)
    @icct = disciplines(:icct)
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  # Test validation rules
  def test_invalid_with_empty_atributes
  	project = Project.new
  	assert !project.valid?
  	assert project.errors.invalid?(:title)
  	assert project.errors.invalid?(:description)
  	assert project.errors.invalid?(:created_by)
  end

  def test_unique_title
  	project = Project.new(:title => projects(:project1).title,
  		:description => "A dummy project",
  		:created_by => users(:academic).id)

  	assert !project.save
  	assert_equal "has already been taken", project.errors.on(:title)
  end

  def test_project_creator_is_valid
      users = User.find(:all)
      users.each do |user|
      	if user.has_role?('staff')
			projects = Project.find(:all,
			   :conditions => ["created_by = ?", user.id])
			projects.each do |project|
				assert_equal project.created_by, user.id,
				   "user #{user.id} didn't create project #{project.id}"
			end
      	end
  	  end
  end

  def test_project_can_be_carbon_critical
  	assert !@project.carbon_critical,
  		"project by default should not be carbon critical"
  	@project.carbon_critical = true
  	assert @project.carbon_critical,
  		"project by should now be carbon critical"
  end

  def test_project_not_assigned_to_discipline
  	@disciplines.each do |discipline|
  		assert !@project.suitable_for?(discipline.name)
  	end
  end

  def test_project_assigned_to_discipline
  	discipline = @icct
  	@project.disciplines << discipline
  	assert @project.suitable_for?(discipline.name)
  end

  def test_project_suitable_for_all
  	@disciplines.each do |discipline|
  		@project.disciplines << discipline
  	end
    assert @project.suitable_for_all?,
       "Project should suit all disciplines"
  end

  def test_unnassigned_project_not_suitable_for_all
    assert ! @project.suitable_for_all?,
       "Unaasigned project should not suit all disciplines"
  end

  def test_singly_assigned_project_not_suitable_for_all
  	@project.disciplines << @icct
    assert ! @project.suitable_for_all?,
       "Project assigned to one discipline should not suit all disciplines"
  end

  def test_project_assigned_to_all_but_one_discipline_not_suitable_for_all
  	@disciplines.each do |discipline|
  		@project.disciplines << discipline
  	end

  	# Remove last discipline
  	@project.disciplines.delete(disciplines(:sport))
    assert ! @project.suitable_for_all?,
       "Project assigned to all but one discipline should not suit all disciplines"
  end

  def test_suitable_for_any
  	assert ! @project.suitable_for_any?, "Project should not be suitable for any"
  	@project.disciplines << @icct
  	assert @project.suitable_for_any?, "Project should be suitable for any"
  end

  def test_suitable_for_discipline
  	assert ! @project.suitable_for_any?,
  	    "Project should not be suitable for any discipine"
  	discipline = @icct
  	@project.suitable_for(discipline.name)
  	assert @project.suitable_for?(discipline.name),
  	    "project should now be suitable for #{discipline.name}"
  end

  def test_cant_add_unknown_discipline_to_project
  	@project.suitable_for('cheesemakers')
  	assert @project.disciplines.count(:all) == 0,
  	  "There should be no cheesemakers"
  end

  def test_cant_add_duplicate_discipline_to_project
  	@project.suitable_for(@icct.name)
  	assert @project.disciplines.count(:all) == 1,
  	  "Should be 1 suitable discipline for project"
  	@project.suitable_for(@icct.name)
  	assert @project.disciplines.count(:all) == 1,
  	  "Should still be 1 suitable discipline for project"
  	@project.suitable_for(disciplines(:eee).name)
  	assert @project.disciplines.count(:all) == 2,
  	  "Should now be 2 suitable discipline for project"
  end

  def test_suitable_for_all
  	@project.suitable_for_all
  	assert @project.suitable_for_all?, "Project is suitable for all"
  end

  def test_discipline_suitable_for_none
  	@project.suitable_for_all
  	@project.suitable_for_none
  	assert ! @project.suitable_for_all?, "Project is suitable for all"
  	assert ! @project.suitable_for_any?, "Project is not suitable for any"
  end

  def test_discipline_suitable_for_none?
  	@project.suitable_for_all
  	@project.suitable_for_none
  	assert @project.suitable_for_none?, "Project is suitable for none"
  end
end
