# == Schema Information
# Schema version: 20090615085710
#
# Table name: projects
#
#  id              :integer         not null, primary key
#  supervisor_id   :integer
#  title           :string(255)
#  description     :text
#  resources       :text
#  created_at      :datetime
#  updated_at      :datetime
#  carbon_critical :boolean
#  sure            :boolean
#  allocated       :boolean
#  round           :integer         default(0)
#  student_id      :integer
#  available       :boolean         default(TRUE)
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

class Project < ActiveRecord::Base
  has_and_belongs_to_many :disciplines
  belongs_to :supervisor # created_by
  has_many :selected_projects, :dependent => :delete_all
  belongs_to :student # allocation

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :description
  validates_presence_of :supervisor_id

  delegate :abbrev, :title, :to => "supervisor.research_centre.nil? ? false : supervisor.research_centre", :prefix => :centre
  
  # TODO: validator should check that at least one discipline has been specified
	  
  # Helper methods
  
  # Test that project is suitable for a discipline
  def suitable_for?(discipline)
    name = name_discipline(discipline)
    count = self.disciplines.count(:conditions => ['name = ?', name])
    return count > 0
  end
  
  # Convenience method to test if a project is suitable for all disciplines
  def suitable_for_all?
   	return self.disciplines.count(:all) == Discipline.count(:all)
  end

  # Convenience method to test if a project is suitable for any discipline
  def suitable_for_any?
  	return self.disciplines.count > 0
  end
  
  # Convenience method to make project suitable for all disciplies
  def suitable_for_all
  	disciplines = Discipline.find(:all)
  	disciplines.each do |discipline|
  		self.suitable_for(discipline.name)
  	end
  end
  
  # Convenience method to add make a project suitable for a named discipline
  def suitable_for(discipline)
    discipline_by_name = name_discipline(discipline)
    return unless discipline_by_name
  	unless  self.suitable_for?(discipline_by_name)
  		if the_discipline = Discipline.find_by_name(discipline_by_name)
  		  self.disciplines << the_discipline
  		end
  	end
  end

  def suitable_for_these(array)
    array.each { |d| self.suitable_for(d) }
  end
  
  # Convenience method to determine if a project is suitable for no disciplines.
  # That is has not been assigned to any disciplines.
  def suitable_for_none?
  	return self.disciplines.empty?
  end
  
  # Convenience method to clear suitability record, e.g. when resetting
  # disciplines in an update method
  def suitable_for_none
  	self.disciplines.delete_all
  end

  # User attached by created_by attribute
  def creator
    self.supervisor
  end

  def centre
    return self.supervisor.research_centre
  end

  def created_by
    return self.supervisor
  end

  def created_by=(supervisor)
    self.supervisor = supervisor
  end
  
  private

  def name_discipline(discipline)
    return discipline.name if discipline.class == Discipline
    return Discipline.find(discipline).name if discipline.class == Fixnum
    return discipline if discipline.class == String
    return discipline.to_s || "" # catch all
  end
end
