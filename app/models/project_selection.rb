# == Schema Information
# Schema version: 20090624122252
#
# Table name: project_selections
#
#  id         :integer         not null, primary key
#  student_id :integer
#  created_at :datetime
#  updated_at :datetime
#  round      :integer
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

class ProjectSelection < ActiveRecord::Base
  acts_as_reportable
  has_many :selected_projects, :order => :position, :dependent => :delete_all
  belongs_to :student
  validates_presence_of :student_id, :round
  validates_numericality_of :student_id, :round 
  # attr_readonly :student_id, :round

  def deselect(project)
    sp = self.selected_projects.find_by_project_id(project)
    sp.destroy unless sp.nil?
    self.selected_projects.reload
  end

  def projects
    return self.selected_projects.map { |sp| sp.project }
  end


  def selected_project
    # TODO: do something here
  end
end
