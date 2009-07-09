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
#
class ProjectAllocationReport < Ruport::Controller

  stage :list

  def setup
    self.data = ProjectAllocation.report_table(:all,
      :only => [:project_id, :title, :sid, :student_name, :student_email, :discipline, :supervisor_name, :supervisor_email, :research_centre, :sure, :carbon_critical],
      :except => ['student_id', 'created_at', 'updated_at', 'supervisor_id', 'id'],
      :methods => [:title, :sure, :carbon_critical, :sid, :student_email, :discipline, :student_name, :supervisor_name, :supervisor_email, :research_centre], :order => 'project_id')
  end

  formatter :html do
    build :list do
      output << textile("h3. Project Allocation List")
      output << data.to_html
    end
  end

  formatter :csv do
    build :list do
      output << data.to_csv
    end
  end
end

