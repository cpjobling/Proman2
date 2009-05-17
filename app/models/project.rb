class Project < ActiveRecord::Base
	  has_and_belongs_to_many :disciplines
	  
   # Helper methods
  
   # Test that project is suitable for a discipline
   def suitable_for?(discipline)
     return self.disciplines.find_by_name(discipline)
   end
  
   # Convenience method to test if a project is suitable for all disciplines
   def suitable_for_all?
   	return self.disciplines.count(:all) == Discipline.count(:all)
   end

   # Convenience method to test if a project is suitable for any discipline
   def suitable_for_any?
  	return self.disciplines.count > 0
   end
  
  # Convenience method to make project suitable for all disciplies
  def suitable_for_all
  	disciplines = Discipline.find(:all)
  	disciplines.each do |discipline|
  		self.suitable_for(discipline.name)
  	end
  end
  
  # Convenience method to add make a project suitable for a named discipline
  def suitable_for(discipline)
  	if ! self.suitable_for?(discipline)
  		if the_discipline = Discipline.find_by_name(discipline)
  		  self.disciplines << the_discipline
  		end
  	end
  end
  
  # Convenience method to determine if a project is suitable for no disciplines.
  # That is has not been assigned to any disciplines.
  def suitable_for_none?
  	return self.disciplines.empty?
  end
  
  # Convenience method to clear suitability record, e.g. when resetting
  # disciplines in an update method
  def suitable_for_none
  	self.disciplines.delete_all
  end
end
