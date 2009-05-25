class Student < ActiveRecord::Base
  has_one :user
  belongs_to :discipline
  has_one :project, :through => :project_allocation
  has_many :selections, :through => :project_selections, :source => :project
end
