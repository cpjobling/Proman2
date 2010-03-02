# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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
