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

module DisciplineHelper

    def select_discipline(label = "Select discipline")
      @disciplines = Discipline.find(:all, :order => "long_name")
      options = ''
      @disciplines.each do |discipline|
        options += "<option value=\"#{discipline.id}\">#{discipline.long_name}</option>"
      end
      return "<label for=\"discipline\">#{label}: #{select_tag("discipline", options)}</label>"
    end
end
