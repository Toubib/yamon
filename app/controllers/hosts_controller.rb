class HostsController < ApplicationController

  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update, :destroy, :tag, :untag]
  before_action :set_host, only: [:destroy, :show, :edit, :update]

  # GET /hosts
  # GET /hosts.xml
  def index
    @hosts = Host.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hosts }
    end
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
  end

  # GET /hosts/new
  # GET /hosts/new.xml
  def new
    @host = Host.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @host }
    end
  end

  # GET /hosts/1/edit
  def edit
  end

  # POST /hosts
  # POST /hosts.xml
  def create
    @host = Host.new(host_params)

    respond_to do |format|
      if @host.save
        flash[:notice] = 'Host was successfully created.'
        format.html { redirect_to(@host) }
        format.xml  { render :xml => @host, :status => :created, :location => @host }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hosts/1
  # PUT /hosts/1.xml
  def update
    respond_to do |format|
      if @host.update_attributes(host_params)
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to(@host) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.xml
  def destroy
    @host.destroy

    respond_to do |format|
      format.html { redirect_to(hosts_url) }
      format.xml  { head :ok }
    end
  end

  # tag a host  #TODO add error flash
  def tag
    HostsHosttag.create(:hosttag_id => params[:hosttag_id],
                                 :host_id => params[:host_id])
    flash[:notice] = "Tag added"
    redirect_to :action => :edit, :id => params[:host_id]
  end

  # untag a host
  #TODO add error flash
  def untag
    host=Host.find(params[:host_id])
    hosttag=Hosttag.find(params[:hosttag_id])
    host.hosttags.delete(hosttag)
#    HostsHosttag.destroy_all({:hosttag_id => params[:hosttag_id],
#                                       :host_id => params[:report_id]})
    flash[:notice] = "Tag removed"
    redirect_to :action => :edit, :id => params[:host_id]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_host
    @host = Host.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def host_params
    params.require(:host).permit(:name, :notification_delay)
  end

end
