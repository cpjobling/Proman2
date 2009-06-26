# Find project selections for students
def grab
	[437421, 486925, 402233, 440582, 484904, 493842, 445414, 487653, 385583, 488067, 449514, 441927, 364030, 448119, 369937, 447833].each do |s|
  student = Student.find_by_student_id(s.to_s)
  ps = student.project_selection
  spc = ps.selected_projects.count
  puts "--------------------------------------------"
  puts "Student #{student.student_id} PS #{ps.id} SP Count: #{spc}"
  puts "----"
  ps.selected_projects.each do |sp|
  	puts "(#{sp.project_selection_id}, #{sp.position}, #{sp.project_id}),"
  end
 end
end