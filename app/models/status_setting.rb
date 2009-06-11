# == Schema Information
# Schema version: 20090609102805
#
# Table name: status_settings
#
#  id          :integer         not null, primary key
#  code        :integer
#  title       :string(255)
#  message     :text
#  permissions :integer         default(28672)
#  integer     :integer         default(28672)
#  created_at  :datetime
#  updated_at  :datetime
#

#  Copyright 2009 Swansea University.
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  under the License.

class StatusSetting < ActiveRecord::Base
  has_one :status

  composed_of :default_permissions,
    :class_name => "Permissions",
    :mapping => [
    # database  ruby
    %w[ permissions permissions ],
  ],
  :allow_nil => false

  validates_presence_of :code
  validates_uniqueness_of :code
  validates_numericality_of :code
  
  validates_presence_of :message

  #validates_presence_of :permissions
  #validates_inclusion_of :permissions, :in => 0..32767, :message => "should be five octal digits, e.g. 765432"

  #validates_format_of "permissions[permissions]", :with => /[0-7]{5}/, :message => "Must be 5 octal digits (0-7)",  :allow_nil => true, :allow_blank => true
end
