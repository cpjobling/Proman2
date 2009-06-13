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

  test "Discipline long_name cache works" do
    long_names = Discipline::LONG_NAMES
    for long_name in long_names do
      db_record = Discipline.find(long_name[1])
      assert_equal db_record.long_name, long_name[0], "Cached discipline name wasn't #{db_record.long_name}"
      assert_equal db_record.id, long_name[1], "Cached id for #{long_name[1]} was inconsistent with DB record #{db_record.id}"
    end
  end
  
  test "Discipline name cache works" do
    names = Discipline::NAMES
    for name in names do
      db_record = Discipline.find(name[1])
      assert_equal db_record.name, name[0], "Cached discipline name wasn't #{db_record.name}"
      assert_equal db_record.id, name[1], "Cached id for #{name[1]} was inconsistent with DB record #{db_record.id}"
    end
  end
end
