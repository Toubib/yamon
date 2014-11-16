class ServicesController < ApplicationController

  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update, :destroy, :tag, :untag]
  before_action :set_service, only: [:destroy, :show, :edit, :update]

  # GET /services
  # GET /services.xml
  def index
    @services = Service.joins(:host).order('hosts.name','name' ).includes(:servicetags)
    @service_tags = Servicetag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services.to_xml(:include => :host) }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
  end

  # GET /services/new
  # GET /services/new.xml
  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to(@service) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update

    respond_to do |format|
      if @service.update_attributes(service_params)
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to(@service) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end

  # tag a service  #TODO add error flash
  def tag
    ServicesServicetag.create(:servicetag_id => params[:servicetag_id],
				 :service_id => params[:service_id])
    tag = Servicetags.find( params[:servicetag_id] )

    respond_to do |format|
      flash[:notice] = "Tag added"
      format.html { redirect_to :action => :edit, :id => params[:service_id] }
      format.js  { render :text => tag.name }
    end
  end

  # untag a service
  #TODO add error flash
  def untag
    service=Service.find(params[:service_id])
    servicetag=Servicetag.find(params[:servicetag_id])
    service.servicetags.delete(servicetag)
#    ServicesServicetag.destroy_all({:servicetag_id => params[:servicetag_id],
#					:service_id => params[:report_id]})
    flash[:notice] = "Tag removed"
    redirect_to :action => :edit, :id => params[:service_id]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:name, :host_id, :notification_delay)
  end

end
