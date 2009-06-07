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

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'permissions'

class PermissionsTest < Test::Unit::TestCase
  def test_admin_all_permissions
    perms = [0, 010000, 020000, 030000, 040000, 050000, 060000, 070000]
    expected = [
                '---------------', # 0
                '--x------------', # 1
                '-w-------------', # 2
                '-wx------------', # 3
                'r--------------', # 4
                'r-x------------', # 5
                'rw-------------', # 6
                'rwx------------'  # 7
                ]
    perms.each_with_index do |perm, i|
      assert_equal expected[i], Permissions.new(perm).to_s, "Administrator permissions #{perm} wasn't #{expected[i]}"
    end
  end

  def test_coordinator_all_permissions
    perms = [0, 001000, 002000, 003000, 004000, 005000, 006000, 007000]
    expected = [
                '---------------', # 0
                '-----x---------', # 1
                '----w----------', # 2
                '----wx---------', # 3
                '---r-----------', # 4
                '---r-x---------', # 5
                '---rw----------', # 6
                '---rwx---------'  # 7
                ]
    perms.each_with_index do |perm, i|
      assert_equal expected[i], Permissions.new(perm).to_s, "Coordinator permissions #{perm} wasn't #{expected[i]}"
    end
  end

  def test_staff_all_permissions
    perms = [0, 000100, 000200, 000300, 000400, 000500, 000600, 000700]
    expected = [
                '---------------', # 0
                '--------x------', # 1
                '-------w-------', # 2
                '-------wx------', # 3
                '------r--------', # 4
                '------r-x------', # 5
                '------rw-------', # 6
                '------rwx------'  # 7
                ]
    perms.each_with_index do |perm, i|
      assert_equal expected[i], Permissions.new(perm).to_s, "Staff permissions  #{perm} wasn't #{expected[i]}"
    end
  end

  def test_student_all_permissions
    perms = [0, 000010, 000020, 000030, 000040, 000050, 000060, 000070]
    expected = [
                '---------------', # 0
                '-----------x---', # 1
                '----------w----', # 2
                '----------wx---', # 3
                '---------r-----', # 4
                '---------r-x---', # 5
                '---------rw----', # 6
                '---------rwx---'  # 7
                ]
    perms.each_with_index do |perm, i|
      assert_equal expected[i], Permissions.new(perm).to_s, "Student permissions for #{perm} wasn't #{expected[i]}"
    end
  end


  def test_others_all_permissions
    perms = [0, 000001, 000002, 000003, 000004, 000005, 000006, 000007]
    expected = [
                '---------------', # 0
                '--------------x', # 1
                '-------------w-', # 2
                '-------------wx', # 3
                '------------r--', # 4
                '------------r-x', # 5
                '------------rw-', # 6
                '------------rwx'  # 7
                ]
    perms.each_with_index do |perm, i|
      assert_equal expected[i], Permissions.new(perm).to_s, "Others permissions for #{perm} wasn't #{expected[i]}"
    end
  end

  def test_permissions_to_number
    permissions = Permissions.new(077777)
    assert_equal 077777, permissions.permissions
  end

  def test_all_permissions_to_s
    permissions = Permissions.new(077777)
    assert_equal 'rwxrwxrwxrwxrwx', permissions.to_s
  end

  def test_admin_numerical_permissions
    permissions =  Permissions.new(070000)
    assert_equal 07, permissions.admins
  end

  def test_coordinator_numerical_permissions
    permissions =  Permissions.new(006000)
    assert_equal 06, permissions.coordinators
  end

  def test_staff_numerical_permissions
    permissions =  Permissions.new(000500)
    assert_equal 05, permissions.staff
  end

  def test_student_numerical_permissions
    permissions =  Permissions.new(000040)
    assert_equal 04, permissions.students
  end

  def test_others_numerical_permissions
    permissions =  Permissions.new(000002)
    assert_equal 02, permissions.others
  end

  def test_perm_to_string
    perms = [0, 1, 2, 3, 4, 5, 6, 7]
    expected = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
    perms.each_with_index do |i, permission|
      assert_equal expected[i], Permissions.as_string(perms[i]), "Permission wasn't #{expected[i]}"
    end
  end

 def test_permissions_to_octal_works
    assert_equal 077777, Permissions.perms2octal('77777')
    assert_equal 0, Permissions.perms2octal('777777')
    assert_equal 0, Permissions.perms2octal('87777')
    assert_equal 0, Permissions.perms2octal('-1')
    assert_equal 0, Permissions.perms2octal('7')
    assert_equal 0, Permissions.perms2octal('77')
    assert_equal 0, Permissions.perms2octal('777')
    assert_equal 0, Permissions.perms2octal('7777')
  end

  def test_to_octal
    assert_equal '11111', Permissions.new(011111).to_octal
    assert_equal '22222', Permissions.new(022222).to_octal
    assert_equal '33333', Permissions.new(033333).to_octal
    assert_equal '44444', Permissions.new(044444).to_octal
    assert_equal '55555', Permissions.new(055555).to_octal
    assert_equal '66666', Permissions.new(066666).to_octal
    assert_equal '77777', Permissions.new(077777).to_octal
    assert_equal '70000', Permissions.new(070000).to_octal
    assert_equal '77000', Permissions.new(077000).to_octal
    assert_equal '77700', Permissions.new(077700).to_octal
    assert_equal '77770', Permissions.new(077770).to_octal
  end

    def test_to_octal_with_leading_0
    assert_equal '00000', Permissions.new(0).to_octal
    assert_equal '00001', Permissions.new(01).to_octal
    assert_equal '00020', Permissions.new(020).to_octal
    assert_equal '00300', Permissions.new(0300).to_octal
    assert_equal '04000', Permissions.new(04000).to_octal
    assert_equal '50000', Permissions.new(050000).to_octal
  end

end
