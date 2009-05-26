class ResearchCentre < ActiveRecord::Base
  has_and_belongs_to_many :supervisors
  has_one :coordinator
end
