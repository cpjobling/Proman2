require File.dirname(__FILE__) + '/../test_helper'

class DisciplineTest < ActiveSupport::TestCase
  fixtures :projects, :disciplines
  
  def setup
  	@project = projects(:project1)
  	@icct = disciplines(:icct)
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_projects_disciplines_projects_includes_project
    # test that adding a discipline adds the discipline
    @project.suitable_for(@icct.name)
    the_project = @icct.projects.find_by_title(@project.title)
    assert @project == the_project
  end
  
  
  
  
end
