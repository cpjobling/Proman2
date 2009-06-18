class InitializeStatusRecord < ActiveRecord::Migration
  def self.up
    # Create status record
    status = Status.new(:id => 1)
    default_setting = StatusSetting.find_by_code(100)
    status.status_setting = default_setting
    status.save!


    # Now add owner to all existing status settings
    settings = StatusSetting.find(:all)
    settings.each do |s|
      s.status = status
      s.save!
    end

  end

  def self.down
    Status.delete_all
  end
end
