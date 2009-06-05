# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem

  before_filter :login_required
  helper_method :owner?
  helper_method :admin?
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  #rescue_from User::NotAuthorized, :with => :user_not_authorized

private

  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_to :back
  end

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  
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
