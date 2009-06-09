module StatusHelper
  def system_status
    status = Status.find(1)
    return status.status_setting.message
  end
end
