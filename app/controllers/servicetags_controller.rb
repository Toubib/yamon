class ServicetagsController < ApplicationController

  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update, :destroy]
  before_action :set_servicetag, only: [:destroy, :show, :edit, :update]

  # GET /servicetags
  # GET /servicetags.xml
  def index
    @servicetags = Servicetag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servicetags }
    end
  end

  # GET /servicetags/1
  # GET /servicetags/1.xml
  def show
  end

  # GET /servicetags/new
  # GET /servicetags/new.xml
  def new
    @servicetag = Servicetag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @servicetag }
    end
  end

  # GET /servicetags/1/edit
  def edit
  end

  # POST /servicetags
  # POST /servicetags.xml
  def create
    @servicetag = Servicetag.new(servicetag_params)

    respond_to do |format|
      if @servicetag.save
        flash[:notice] = 'servicetag was successfully created.'
        format.html { redirect_to(@servicetag) }
        format.xml  { render :xml => @servicetag, :status => :created, :location => @servicetag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @servicetag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servicetags/1
  # PUT /servicetags/1.xml
  def update
    respond_to do |format|
      if @servicetag.update_attributes(servicetag_params)
        flash[:notice] = 'servicetag was successfully updated.'
        format.html { redirect_to(@servicetag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @servicetag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servicetags/1
  # DELETE /servicetags/1.xml
  def destroy
    @servicetag.destroy

    respond_to do |format|
      format.html { redirect_to(servicetags_url) }
      format.xml  { head :ok }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_servicetag
    @servicetag = Servicetag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def servicetag_params
    params.require(:servicetag).permit(:name, :description, :css_classes)
  end

end
