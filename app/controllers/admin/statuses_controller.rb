class Admin::StatusesController < ApplicationController
  # GET /admin/statuses
  # GET /admin/statuses.xml
  def index
    @status = Status.find(1)

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @status }
    end
  end

  # GET /admin/statuses/1
  # GET /admin/statuses/1.xml
  def show
    @status = Status.find(1)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /admin/statuses/new
  # GET /admin/statuses/new.xml
  def new
    @status = Status.find(1)
    @current_setting = @status.status_setting
    @settings = StatusSetting.find(:all, :order => 'code')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /admin/statuses/1/edit
  def edit
    @status = Status.find(1)
    @current_setting = @status.status_setting
    @settings = StatusSetting.find(:all, :order => 'code')
  end

  # POST /admin/statuses
  # POST /admin/statuses.xml
  def create
    @status = Status.find(1)
    status = params[:status]
    status_setting_id = status[:status_setting]
    @status.status_setting = StatusSetting.find(status_setting_id.to_i)

    respond_to do |format|
      if @status.save
        flash[:notice] = 'Status was successfully updated.'
        format.html { redirect_to(admin_status_path(@status)) }
        format.xml  { render :xml => @status, :status => :created, :location => @status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/statuses/1
  # PUT /admin/statuses/1.xml
  def update
    @status = Status.find(1)
    status = params[:status]
    status_setting_id = status[:status_setting]
    @status.status_setting = StatusSetting.find(status_setting_id.to_i)
    respond_to do |format|
      if @status.save
        flash[:notice] = 'Status was successfully updated.'
        format.html { redirect_to(admin_status_path(@status)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
      end
    end
  end
end
