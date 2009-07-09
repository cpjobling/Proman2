# == Schema Information
# Schema version: 20090624122252
#
# Table name: statuses
#
#  id                :integer         not null, primary key
#  status_setting_id :integer         default(1)
#  created_at        :datetime
#  updated_at        :datetime
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

class Status < ActiveRecord::Base
  acts_as_reportable
  belongs_to :status_setting

  delegate :code, :title, :message, :permissions, :default_permissions, :octal_permissions,
    :can_select?, :can_allocate?, :selection_round, :to => :status_setting
end
