class AddStudentDataToStiRecords < ActiveRecord::Migration
  def self.up
    sql = ActiveRecord::Base.connection
    students = OriginalStudent.find(:all)
    for s in students do
      # couldn't find a reliable way to do this in rails
      puts s.id
      if s.user.nil?
        puts "Warning: copy failed for record with student record id: #{s.id}"
        next
      end
      #puts "processing #{s.user.name}"
      query = <<EOQ
UPDATE users
SET type='Student', grade=#{s.grade}, discipline_id=#{s.discipline_id}, student_number='#{s.student_id}'
WHERE id = #{s.user.id}
EOQ
      puts "Executing: #{query}"
      sql.execute(query)
      puts "OK...next"
    end
  end
  def self.down
  end
end
