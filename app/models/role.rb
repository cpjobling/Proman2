# == Schema Information
# Schema version: 20090612173705
#
# Table name: roles
#
#  id   :integer         not null, primary key
#  name :string(255)
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

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  # Recipe 61 "Look up constant data efficiently" in Adanced Rails Recipes
  ROLES = self.find(:all, :order => :name).map do |r|
    [r.name, r.id]
  end
end
