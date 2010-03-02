require 'test_helper'

class SelectedProjectTest < ActiveSupport::TestCase

  should_belong_to :project_selection
  should_belong_to :project

  context "with project selections" do
    setup do
      @sp = SelectedProject.all
    end
    
    should "have 10 projects" do
      assert_equal 10, @sp.size
    end

    context "a project in project selections" do
      setup do
        @project = projects(:project3)
      end

      should "have project 1 in 2 different project selections" do
        selected_projects = SelectedProject.find_all_by_project_id(@project)
        assert_equal 2, selected_projects.size
      end

      should "belong to project selections 1 and 2" do
        selected_projects = SelectedProject.find_all_by_project_id(@project)
        selected_projects.each do |sp|
          assert sp.project_selection == project_selections(:one) || sp.project_selection == project_selections(:two)
        end
      end

      should "be able to remove project from all selections with drop_from_selections" do
        SelectedProject.drop_from_all_selections(@project)
        selected_projects = SelectedProject.find_all_by_project_id(@project)
        assert_equal 0, selected_projects.size, "project selections should be seleted"
        assert_equal 8, SelectedProject.count, "should be 2 less projects in the selections"
        assert Project.find(@project.id), "shouldn't delete project!"
        assert_equal 4, project_selections(:one).selected_projects.count, "ps1 should have lost a project selection"
        assert_equal 4, project_selections(:two).selected_projects.count, "ps2 should have lost a project selection"
      end
    end
  end
end
