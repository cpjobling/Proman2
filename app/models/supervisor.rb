# == Schema Information
# Schema version: 20090624122252
#
# Table name: supervisors
#
#  id                 :integer         not null, primary key
#  research_centre_id :integer
#  user_id            :integer
#  staff_id           :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  loading            :integer         default(4)
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

class Supervisor < ActiveRecord::Base
  acts_as_reportable
  belongs_to :user
  belongs_to :research_centre
  has_many :students, :through => :project_allocations

  validates_presence_of :user_id, :staff_id, :research_centre_id

  validates_uniqueness_of :staff_id
  validates_length_of :staff_id, :in => 5..10
  validates_numericality_of :staff_id, :user_id, :research_centre_id, :loading
  validates_presence_of :loading, :allow_blank => true, :allow_nil => true

  delegate :name, :email, :to => :user
  delegate :abbrev, :title, :to => :research_centre, :prefix => :rc

  def projects
    return self.user.projects
  end

  def add_student
    raise "supervisor.add_student; can't add student because supervisor's load (#{self.loading}) would be exceeded" if self.has_full_allocation?
    write_attribute('load', read_attribute('load') + 1)
  end

  def remove_student
    load = read_attribute('load')
    write_attribute('load', load - 1) unless load == 0
  end

  def has_full_allocation?
    return read_attribute('load') >= read_attribute('loading')
  end

  def load
    return read_attribute('load')
  end

  def load=(load)
    write_attribute('load', load)
  end

end
