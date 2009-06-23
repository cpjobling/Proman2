# == Schema Information
# Schema version: 20090621110215
#
# Table name: students
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  grade          :decimal(, )
#  discipline_id  :integer
#  student_id     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  board_decision :string(255)
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

class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :discipline
  # Student can be allocated one project.
  # Project becomes de-allocated if student is deleted.
  has_one :project, :dependent => :nullify
  # Student has a projects selection, which
  # if student is destroyed, is also destroyed
  has_one :project_selection, :dependent => :destroy

  validates_length_of :student_id, :in => 6..10
  validates_numericality_of :student_id
  validates_uniqueness_of :student_id
  validates_presence_of :student_id, :user_id, :discipline_id
  validates_presence_of :grade, :allow_nil => true, :allow_blank => :true
  validates_numericality_of :grade, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  delegate :name, :email, :to => :user
  delegate :name, :long_name, :to => "discipline.nil? ? false : discipline", :prefix => :disc

  # Allocate a project to this student if the project is in the students selected projects.
  def allocate(project)
    return unless project_selection.selected_projects.find_by_project_id(project.id)
    project.allocate(self, project_selection.round)
  end
  
  def deselect(project)
    project_selection.deselect(project)
  end

  def drop_selection
    return if project_selection.nil?
    project_selection.destroy
    self.reload
  end

  def selection
    return project_selection.projects
  end
end
