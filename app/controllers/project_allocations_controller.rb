class ProjectAllocationsController < ApplicationController
  # GET /project_allocations
  # GET /project_allocations.xml
  def index
    @project_allocations = ProjectAllocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_allocations }
    end
  end

  # GET /project_allocations/1
  # GET /project_allocations/1.xml
  def show
    @project_allocation = ProjectAllocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_allocation }
    end
  end

  # GET /project_allocations/new
  # GET /project_allocations/new.xml
  def new
    @project_allocation = ProjectAllocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_allocation }
    end
  end

  # GET /project_allocations/1/edit
  def edit
    @project_allocation = ProjectAllocation.find(params[:id])
  end

  # POST /project_allocations
  # POST /project_allocations.xml
  def create
    @project_allocation = ProjectAllocation.new(params[:project_allocation])

    respond_to do |format|
      if @project_allocation.save
        flash[:notice] = 'ProjectAllocation was successfully created.'
        format.html { redirect_to(@project_allocation) }
        format.xml  { render :xml => @project_allocation, :status => :created, :location => @project_allocation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_allocation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_allocations/1
  # PUT /project_allocations/1.xml
  def update
    @project_allocation = ProjectAllocation.find(params[:id])

    respond_to do |format|
      if @project_allocation.update_attributes(params[:project_allocation])
        flash[:notice] = 'ProjectAllocation was successfully updated.'
        format.html { redirect_to(@project_allocation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_allocation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_allocations/1
  # DELETE /project_allocations/1.xml
  def destroy
    @project_allocation = ProjectAllocation.find(params[:id])
    @project_allocation.destroy

    respond_to do |format|
      format.html { redirect_to(project_allocations_url) }
      format.xml  { head :ok }
    end
  end
end
