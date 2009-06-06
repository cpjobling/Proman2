class Admin::StatusSettingsController < ApplicationController

  current_tab :admin
  require_role "admin"

  # GET /admin/status_settings
  # GET /admin/status_settings.xml
  def index
    @settings = StatusSetting.find(:all, :order=>'code')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @status_settings }
    end
  end

  # GET /admin/status_settings/1
  # GET /admin/status_settings/1.xml
  def show
    @setting = StatusSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end
end
