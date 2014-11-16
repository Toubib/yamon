class AlertsController < ApplicationController

  before_filter :get_parent
  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update, :destroy]
  before_action :set_alert, only: [:destroy, :show, :edit, :update]

  # GET /alerts
  # GET /alerts.xml
  def index
    if @alerts.nil?

      @alertFilter = find_filter
      @alertFilter.setFromParams(params)
      
      scope=Alert.scoped({})
      scope = scope.scoped :order => "date_start DESC"
      scope = scope.scoped :joins => "left join services on services.id = alerts.service_id"
      scope = scope.scoped :joins => :host
      
      #String query parameters
      scope = scope.scoped :conditions => ['duration >= ?*60',@alertFilter.dmin] unless @alertFilter.dmin.blank?
      scope = scope.scoped :conditions => ['duration < ?*60',@alertFilter.dmax] unless @alertFilter.dmax.blank?
      scope = scope.scoped :conditions => ['date_start >= ?',@alertFilter.dfrom] unless @alertFilter.dfrom.blank?
      scope = scope.scoped :conditions => ['date_end <= ?',@alertFilter.dto] unless @alertFilter.dto.blank?
      scope = scope.scoped :conditions => ['services.name = ?',@alertFilter.idesc.strip] unless @alertFilter.idesc.blank?
      scope = scope.scoped :conditions => ['hosts.name = ?',@alertFilter.ihost.strip] unless @alertFilter.ihost.blank?
      scope = scope.scoped :conditions => ['check_status = ?',@alertFilter.check_status] unless @alertFilter.check_status.blank?
      
      #array query parameters
      @alertFilter.edesc.split(',').each { |i|
      	scope = scope.scoped :conditions => ['services.name != ?',i.strip]
      } if !@alertFilter.edesc.blank?
      
      @alertFilter.ehost.split(',').each { |i|
      	scope = scope.scoped :conditions => ['hosts.name != ?',i.strip]
      } if !@alertFilter.ehost.blank?
      
      #get alerts number
      @alert_count = scope.size

      #set limit to get
      scope = scope.scoped :limit => @alertFilter.limit

      #exec query
      @alerts = scope
      
      @reportList = Report.order('select_priority DESC,estimated_date')
      @check_status_selected = @alertFilter.check_status || Alert::ALERT_STATUS_BY_KEY['ERROR']

    end

    #set label limit value
    if @alertFilter.limit > @alerts.size
      @limitLabel = @alerts.size
      @limitStyle = ""
    else
      @limitLabel = @alertFilter.limit
      @limitStyle = "limitAlert"
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alerts }
    end
  end

  # GET /alerts/1
 # GET /alerts/1.xml
  def show
  end

  # GET /alerts/new
  # GET /alerts/new.xml
  def new
    @alert = Alert.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alert }
    end
  end

  # GET /alerts/1/edit
  def edit
  end

  # POST /alerts
  # POST /alerts.xml
  def create
    @alert = Alert.new(alert_params)

    respond_to do |format|
      if @alert.save
        flash[:notice] = 'Alert was successfully created.'
        format.html { redirect_to(@alert) }
        format.xml  { render :xml => @alert, :status => :created, :location => @alert }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @alert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /alerts/1
  # PUT /alerts/1.xml
  def update
    respond_to do |format|
      if @alert.update_attributes(alert_params)
        flash[:notice] = 'Alert was successfully updated.'
        format.html { redirect_to(@alert) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.xml
  def destroy
    @alert.destroy

    respond_to do |format|
      format.html { redirect_to(alerts_url) }
      format.xml  { head :ok }
    end
  end

  # link a given alert to a report
  def link_to_report
    params.each { |key,value|
 
      next if !key.starts_with?('alert;')

      a=Alert.find(value)
      if params[:report_id] == "0"
        a.report_id=nil
        a.save
        flash[:notice] = "Link deleted"
      else
        a.report_id=params[:report_id]
        a.save
        flash[:notice] = "Link added"
      end
    }
    redirect_to :action => :index
  end
private

  #get alerts object if we have a service_id in params
  def get_parent
    @alerts = Alert.find_all_by_service_id(params[:service_id]) unless params[:service_id].blank?
  end

  #get filter object from session or create it
  def find_filter
    session[:alertFilter] ||= AlertFilter.new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_alert
    @alert = Alert.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def alert_params
    params.require(:alert).permit(:date_start, :date_end, :check_status, :service_output, :service_perfdata, :duration, :service_id, :report_id, :host_id)
  end

end
