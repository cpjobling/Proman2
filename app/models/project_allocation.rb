# == Schema Information
# Schema version: 20090624122252
#
# Table name: project_allocations
#
#  id               :integer         not null, primary key
#  student_id       :integer         not null
#  project_id       :integer         not null
#  supervisor_id    :integer         not null
#  allocation_round :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#

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

class ProjectAllocation < ActiveRecord::Base
  acts_as_reportable
  belongs_to :student
  belongs_to :project
  belongs_to :supervisor

  delegate :title, :sure, :carbon_critical, :to => :project
  delegate :email, :discipline, :to => :student, :prefix => 'student'
  delegate :email, :research_centre, :loading, :to => :supervisor, :prefix => 'supervisor'
  def deallocate
    p = Project.find(self.project_id)
    p.deallocate
  end

  def sid
    return self.student.student_id
  end

  def discipline
    return student.discipline.name
  end

  def research_centre
    return supervisor.research_centre.abbrev
  end

  def student_name
    return student.name.last_first
  end

  def supervisor_name
    return supervisor.name.last_first
  end
end
