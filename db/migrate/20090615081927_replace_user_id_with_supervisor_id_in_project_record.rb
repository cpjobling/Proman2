class ReplaceUserIdWithSupervisorIdInProjectRecord < ActiveRecord::Migration
  def self.up
    #
    # Now re-arrange data from user_id to supervisor_id
    projects = Project.all
    for project in projects do
      user = User.find(project.created_by)
      supervisor = user.supervisor
      project.created_by = supervisor.id
      project.save!
    end
  end

  def self.down
    projects = Project.all
    for project in projects do
      supervisor = Supervisor.find(project.created_by)
      user = supervisor.user
      project.created_by = user.id
      project.save!
    end
  end
end
