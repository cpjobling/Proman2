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

module ResearchCentreHelper
  def select_research_centre(label = "Select research centre")
    @research_centres = ResearchCentre.find(:all, :order => "title")
    options = ''
    @research_centres.each do |research_centre|
      options += "<option value=\"#{research_centre.id}\">#{research_centre.title}</option>"
    end
    return "<label for=\"research_centre\">#{label}: #{select_tag("research_centre", options)}</label>"
  end
end
