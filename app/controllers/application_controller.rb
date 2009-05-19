# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem

  before_filter :login_required
  helper_method :owner?
  helper_method :admin?
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected

  def owner?
    # TODO write this method
    true
  end

  def admin?
    # TODO write this method
    true
  end

end
