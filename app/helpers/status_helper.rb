module StatusHelper
  def system_status
    status = Status.first
    status_message = "<h3>#{status.title}</h3>#{textilize(status.message)}"
    return status_message
  end
end
