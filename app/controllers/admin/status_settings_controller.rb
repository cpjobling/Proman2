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
require 'permissions'
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
    @setting.default_permissions = Permissions.new(070000) # default permissions


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
    @setting = StatusSetting.new(params[:status_setting])

    respond_to do |format|
      if @setting.save
        flash[:notice] = 'status_setting was successfully created.'
        format.html { redirect_to(admin_status_setting_path(@setting)) }
        format.xml  { render :xml => @setting, :status => :created, :location => @setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/status_settings/1
  # PUT /admin/status_settings/1.xml
  def update
    @setting = StatusSetting.find(params[:id])
    
    respond_to do |format|
        if @setting.update_attributes(params[:status_setting])
          flash[:notice] = 'status_setting was successfully updated.'
          format.html { redirect_to(admin_status_setting_path(@setting)) }
          format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/status_settings/1
  # DELETE /admin/status_settings/1.xml
  def destroy
    @setting = StatusSetting.find(params[:id])
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to(admin_status_settings_path) }
      format.xml  { head :ok }
    end
  end
    
  private

  def get_permissions
    return Permissions.new()
    perms = ( params['permissions[admins_r'] * 4 +
              params['permissions[admins_w'] * 2 +
              params['permissions[admins_x'] * 1 ) * 0100000 +
            ( params['permissions[coordinators_r'] * 4 +
              params['permissions[coordinators_w'] * 2  +
              params['permissions[coordinators_x'] * 1 ) * 01000 +
            ( params['permissions[staff_r'] * 4 +
              params['permissions[staff_w'] * 2  +
              params['permissions[staff_x'] * 1 ) * 0100 +
            ( params['permissions[students_r'] * 4 +
              params['permissions[students_w'] * 2 +
              params['permissions[students_x'] * 1 ) * 010 +
              params['permissions[others_r'] * 4 +
              params['permissions[others_w'] * 2 +
              params['permissions[others_x'] * 1

    return Permissions.new(perms)
  end

end
