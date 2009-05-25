class ProjectSelection < ActiveRecord::Base
  belongs_to :student
  belongs_to :project
  acts_as_list
end
