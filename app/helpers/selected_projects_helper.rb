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
#
module SelectedProjectsHelper
  def rank_in_words(rank)
    the_rank = case
    when rank == 1 then "highest ranked"
    when rank == 2 then "second ranked"
    when rank == 3 then "third ranked"
    when rank == 4 then "fourth ranked"
    when rank == 5 then "fifth ranked"
    when rank == 6 then "sixth ranked"
    when rank == 7 then "seventh ranked"
    when rank == 8 then "eighth ranked"
    when rank == 9 then "ninth ranked"
    when rank == 10 then "tenth ranked"
    else
      "lower than 10th ranked"
    end
    return the_rank
  end
end
