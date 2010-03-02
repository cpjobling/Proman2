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

module ProjectsHelper

  # Return disciplines as a map with long_name as key and disciplines.id
  # as value.
  def collect_disciplines
    disciplines = {}
    Discipline.find(:all).collect do |r|
      disciplines[r.long_name] = r.id
    end
    return disciplines
  end


  # Only owner can edit project
  def can_edit?(project)
    current_user.id == project.created_by
  end

  def abbreviate(text, length=80)
    if text.length > length
      return text[0...length-3] + "..."
    end
    return text
  end

  def add_selection_to_table_header_if(project)
    if project
      return "<th class=\"{sorter: false}\">Select</th>"
    end
  end

  def add_selection_to_table_footer_if(project)
    if project
      return "<th>Select</th>"
    end
  end

  def availability(project)
    if project.available?
      return "available"
    else
      return "not available"
    end
  end

  # Produce a string for use in a link title.
  # projct title: supervisor name (load/loading)
  def title_string_for(project)
    supervisor = project.supervisor
    return h("#{project.title}: #{supervisor.name} (#{supervisor.load}/#{supervisor.loading})")
  end
end