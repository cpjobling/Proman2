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

end