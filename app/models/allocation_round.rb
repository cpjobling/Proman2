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

class AllocationRound < ActiveRecord::Base
  acts_as_reportable
  def set(round)
    self.round = round
  end

  def increment
    self.round = round + 1
  end

  def last_round
    return self.round == 0 || self.round - 1
  end

  def reset
    self.round = 0
  end

  def initial_round?
    return self.round == 1
  end
end
