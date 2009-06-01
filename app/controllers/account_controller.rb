class AccountController < ApplicationController
  before_filter :login_required
  current_tab :my_account

  def index
    
  end
end
