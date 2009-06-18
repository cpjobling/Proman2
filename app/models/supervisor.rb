# == Schema Information
# Schema version: 20090615085710
#
# Table name: supervisors
#
#  id                 :integer         not null, primary key
#  research_centre_id :integer
#  user_id            :integer
#  staff_number           :string(255)
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

class Supervisor < User
  # belongs_to :user
  belongs_to :research_centre
  has_many :projects, :dependent => :destroy

  validates_presence_of :research_centre_id, :staff_number #, :max_projects
  validates_length_of :staff_number, :within=>6..8
  validates_numericality_of :staff_number
  validates_uniqueness_of :staff_number

  delegate :title, :abbrev, :to => "research_centre.nil? ? false : research_centre", :prefix => :rc

  # It should be a validation error to have a supervisor with no centre
  def research_centre_title
    if self.research_centre
      return  self.research_centre.title
    else
      return "Undefined"
    end
  end

  def research_centre_abbrev
    if self.research_centre
      return  self.research_centre.abbrev
    else
      return "N/A"
    end
  end
end
