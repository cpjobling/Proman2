# == Schema Information
# Schema version: 20090619105901
#
# Table name: selected_projects
#
#  id                   :integer         not null, primary key
#  project_selection_id :integer
#  position             :integer
#  project_id           :integer
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

# Represents list of selected projects in a student's project selection
class SelectedProject < ActiveRecord::Base
  belongs_to :project_selection
  acts_as_list :scope => :project_selection
  default_scope :order => :position
  belongs_to :project
end
