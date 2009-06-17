class AddStaffDataToStiRecords < ActiveRecord::Migration
  def self.up

    sql = ActiveRecord::Base.connection
    supervisors = OriginalSupervisor.find(:all)
    for s in supervisors do
      # couldn't find a reliable way to do this in rails
      if s.user.nil?
        puts "Warning: copy failed for Supervisor #{s.id} - #{s.staff_id}"
        next
      end
      query = <<EOQ
UPDATE users
SET type='Supervisor', loading=#{s.loading}, research_centre_id=#{s.research_centre_id}, staff_number='#{s.staff_id}'
WHERE id = #{s.user.id}
EOQ
      #puts "Executing: #{query}"
      sql.execute(query)
    end
  end

  def self.down
    # Do nothing, leave original supervisor table around
  end
end
