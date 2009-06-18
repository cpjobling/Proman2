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

class SupervisorTest < ActiveSupport::TestCase

#  id                 :integer         not null, primary key
#  research_centre_id :integer
#  user_id            :integer
#  staff_id           :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#
  should_validate_presence_of :user_id, :staff_id, :research_centre_id
  should_ensure_length_in_range :staff_id, (5..10)
  should_validate_numericality_of :staff_id, :research_centre_id, :user_id
  should_validate_uniqueness_of :staff_id
  
  should_have_many :projects, :dependent => :delete_all
  should_belong_to :user, :research_centre

  context "supervisors and their projects" do
    setup do
      @supervisor = supervisors(:cpjobling)
    end

    should "have many projects" do
      assert_not_nil @supervisor.projects
      assert_equal 4, @supervisor.projects.count
    end

    context "a supervisor's projects" do
      setup do
        @projects = @supervisor.projects
      end

      should "each be created by the supervisor" do
        @projects.each do |project|
          assert_equal @supervisor, project.supervisor
        end
      end
    end

  end
end
