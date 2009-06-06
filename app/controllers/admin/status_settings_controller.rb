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
      format.xml  { render :xml => @status_setting }
    end
  end

  # GET /admin/status_settings/new
  # GET /admin/status_settings/new.xml
  def new
    @setting = StatusSetting.new


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @setting }
    end
  end

  # GET /admin/status_settings/1/edit
  def edit
    @setting = StatusSetting.find(params[:id])
  end

  # POST /admin/status_settings
  # POST /admin/status_settings.xml
  def create
    @status_setting = StatusSetting.new(params[:status_setting])

    respond_to do |format|
      if @status_setting.save
        flash[:notice] = 'status_setting was successfully created.'
        format.html { redirect_to(admin_status_setting_path(@status_setting)) }
        format.xml  { render :xml => @status_setting, :status => :created, :location => @status_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @status_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/status_settings/1
  # PUT /admin/status_settings/1.xml
  def update
    @status_setting = StatusSetting.find(params[:id])

    respond_to do |format|
      if @status_setting.update_attributes(params[:status_setting])
        flash[:notice] = 'status_setting was successfully updated.'
        format.html { redirect_to(admin_status_setting_path(@status_setting)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @status_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/status_settings/1
  # DELETE /admin/status_settings/1.xml
  def destroy
    @status_setting = StatusSetting.find(params[:id])
    @status_setting.destroy

    respond_to do |format|
      format.html { redirect_to(admin_status_settings_path) }
      format.xml  { head :ok }
    end
  end


end
