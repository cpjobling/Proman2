class Student < ActiveRecord::Base
  has_one :user
  has_one :discipline
  has_one :project, :though => :project_allocation
  has_many :selections, :through => :project_selections, :source => :project
end
