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

require 'active_support'

# Configure settings
module Proman
  module Config
    # Settings

    # Enable project selection
    @@can_select = false
    def self.can_select?
      return @@can_select
    end

    def self.can_select=(value)
      @@can_select = value ? true : false
    end

    @@can_allocate = false
    def self.can_allocate?
      return @@can_allocate
    end

    def self.can_allocate=(value)
      @@can_allocate = value ? true : false
    end

    # Set project selection round
    @@project_selection_round = 0
    def self.current_selection_round
      return @@project_selection_round
    end

    def self.update_selection_round
      @@project_selection_round += 1
    end

    def self.reset_selection_round
      @@project_selection_round = 0
    end

    def self.current_selection_round=(value)
      @@project_selection_round = value
    end
  end
end
