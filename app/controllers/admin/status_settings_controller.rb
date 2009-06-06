class Admin::StatusSettingsController < ApplicationController

  current_tab :admin
  require_role "admin"

  # GET /admin/status_settings
  # GET /admin/status_settings.xml
  def index
    @status_settings = StatusSetting.find(:all, :order=>'code')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @status_settings }
    end
  end
end
