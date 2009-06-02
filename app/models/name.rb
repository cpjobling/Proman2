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

class Name
  attr_reader :title, :first, :last, :initials, :known_as

  def initialize(title, first, last, initials = "", known_as = "")
    @title = title
    @first = first
    @initials = initials
    @last = last
    @known_as = known_as
    @errors = ActiveRecord::Errors.new self
  end

  def to_s
    [ @title, @first, @initials, @last ].compact.join(" ")
  end

  def formally
    [ @title, @last ].compact.join(" ")
  end

  def informally
    if ( @known_as == "")
      return @first
    end
    return @known_as
  end

  def last_first
    return "#{@last}, #{@title} #{@first}, #{@intials}"
  end

  # Apparently needed to satisfy assert_difference when testing composed objects?
  def size
    return 1
  end

end
