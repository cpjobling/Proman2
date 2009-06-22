# == Schema Information
# Schema version: 20090621110215
#
# Table name: status_settings
#
#  id              :integer         not null, primary key
#  code            :integer
#  title           :string(255)
#  message         :text
#  permissions     :integer         default(28672)
#  created_at      :datetime
#  updated_at      :datetime
#  can_select      :boolean
#  can_allocate    :boolean
#  selection_round :integer         default(0)
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

  validates_presence_of :code, :message, :title, :permissions, :selection_round
  validates_uniqueness_of :code
  validates_numericality_of :code, :permissions, :selection_round


  def octal_permissions=(octal_permissions)
    decimal_permissions = Permissions.from_octal(octal_permissions)
    self.permissions = decimal_permissions
  end

  def octal_permissions
    return self.default_permissions.to_octal
  end

  #validates_presence_of :permissions
  #validates_inclusion_of :permissions, :in => 0..32767, :message => "should be five octal digits, e.g. 765432"

  #validates_format_of "permissions[permissions]", :with => /[0-7]{5}/, :message => "Must be 5 octal digits (0-7)",  :allow_nil => true, :allow_blank => true
end
