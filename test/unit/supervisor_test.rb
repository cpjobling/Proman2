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

require 'test_helper'

class SupervisorTest < ActiveSupport::TestCase

  should_validate_presence_of :abbrev, :title
  should_validate_uniqueness_of :abbrev, :title
  should_ensure_length_in_range :abbrev, (3..10)
  should_have_many :supervisors
  should_belong_to :supervisor
end
