require 'test_helper'

include ProjectsHelper

class ProjectsControllerHelpersTest < ActionController::TestCase
  # Test ProjectsController helpers

  test "collect_disciplines works properly" do
    disciplines = Discipline.find(:all)
    collected_disciplines = collect_disciplines

    disciplines.each do |discipline|
      assert collected_disciplines.key?(discipline.long_name),
        "#{discipline.long_name} should be a key"
      assert_equal collected_disciplines[discipline.long_name], discipline.id,
        "collected_disciplines[#{discipline.long_name}] should be #{discipline.id}"
    end
  end
end
