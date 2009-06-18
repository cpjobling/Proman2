# == Schema Information
# Schema version: 20090615085710
#
# Table name: students
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  grade         :decimal(, )
#  discipline_id :integer
#  student_number    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
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

class Student < User
  #belongs_to :user
  belongs_to :discipline
  # Student can be allocated one project.
  # Project becomes de-allocated if student is deleted.
  has_one :project, :dependent => :nullify
  # Student has a projects selection, which
  # if student is destroyed, is also destroyed
  has_one :project_selection, :dependent => :destroy

  validates_presence_of :student_number, :discipline_id
  validates_uniqueness_of :student_number
  validates_numericality_of :student_number
  validates_length_of :student_number, :in => 6..8
  validates_numericality_of :grade, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :grade, :within => 0..100, :allow_nil => true, :allow_blank => true

  delegate :name, :long_name, :to => "discipline.nil? ? false : discipline", :prefix => :disc
end
