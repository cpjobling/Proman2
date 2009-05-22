class DisciplinesProjects < ActiveRecord::Base
    belongs_to :discipline
    belongs_to :project
end