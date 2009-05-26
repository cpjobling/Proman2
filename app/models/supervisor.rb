class Supervisor < ActiveRecord::Base
  has_one :user
  belongs_to :research_centre
  has_many :projects
end
