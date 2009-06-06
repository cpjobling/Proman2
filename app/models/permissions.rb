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

class Permissions
  
  def initialize(permissions)
    value = permissions
    @admin = value / 4096
    value %= 4096
    @coordinator = value / 512
    value %= 512
    @staff = value / 64
    value %= 64
    @student = value / 8
    @others = value % 8
  end

  def admin
    return @admin
  end

  def coordinator
    return @coordinator
  end

  def staff
    return @staff
  end

  def student
    return @student
  end

  def others
    return @others
  end

  def Permissions.as_string(numerical_permission)
    perm = case
    when numerical_permission == 7
      'rwx'
    when numerical_permission == 6
      'rw-'
    when numerical_permission == 5
      'r-x'
    when numerical_permission == 4
      'r--'
    when numerical_permission == 3
      '-wx'
    when numerical_permission == 2
      '-w-'
    when numerical_permission == 1
      '--x'
    when numerical_permission == 0
      '---'
    else
      '---'
    end
    return perm
  end

  def to_s
    return Permissions.as_string(@admin) +
           Permissions.as_string(@coordinator) +
           Permissions.as_string(@staff) +
           Permissions.as_string(@student) +
           Permissions.as_string(@others)
  end

  def to_number
    (@admin * 4096 + @coordinator * 512 + @staff * 64 + @student * 8 + @others)
  end
end
