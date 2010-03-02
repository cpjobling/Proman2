# == Schema Information
# Schema version: 20090624122252
#
# Table name: research_centres
#
#  id          :integer         not null, primary key
#  abbrev      :string(10)
#  title       :string(255)
#  coordinator :integer
#  created_at  :datetime
#  updated_at  :datetime
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

class ResearchCentre < ActiveRecord::Base
  acts_as_reportable
  has_many :supervisors, :dependent => :nullify # put supervisors in limbo when research group deleted
  belongs_to :coordinator, :class_name => 'User', :foreign_key => :coordinator


  validates_presence_of :abbrev, :title
  validates_uniqueness_of :abbrev, :title
  validates_length_of :abbrev, :in => 3..10

  @research_centres = self.find(:all, :order=>'title')
  TITLES = @research_centres.map do |c|
    [c.title, c.id]
  end

  ABBREVS = @research_centres.map do |c|
    [c.abbrev, c.id]
  end

  def ResearchCentre.titles
    TITLES.map {|title| title[0]}
  end

  def ResearchCentre.abbreviations
    ABBREVS.map {|abbrev| abbrev[0]}
  end
end
