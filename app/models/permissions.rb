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
    @admins = value / 4096
    value %= 4096
    @coordinators = value / 512
    value %= 512
    @staff = value / 64
    value %= 64
    @students = value / 8
    @others = value % 8
  end

  def admins
    return @admins
  end

  def coordinators
    return @coordinators
  end

  def staff
    return @staff
  end

  def students
    return @students
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
    return Permissions.as_string(@admins) +
      Permissions.as_string(@coordinators) +
      Permissions.as_string(@staff) +
      Permissions.as_string(@students) +
      Permissions.as_string(@others)
  end

  def permissions
    (@admins * 4096 + @coordinators * 512 + @staff * 64 + @students * 8 + @others)
  end

  # Converts a string like 76544 that would otherwise be considered a decimal
  # into an octal. Returns zero if digits are not correct format
  def Permissions.from_octal(octal_string)
    return 0 unless octal_string =~ /^[0-7]{5}$/
    d = octal_string.to_i(8)
    return d
  end

  def to_octal
    return '%05o' % self.permissions
  end

  def ==(other)
    return false unless other.class == Permissions
    return false if other.nil?
    return self.permissions == other.permissions
  end
end
