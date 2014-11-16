class ReportsController < ApplicationController

  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update, :destroy, :tag, :untag]
  before_action :set_report, only: [:destroy, :show, :edit, :update]

  # GET /reports
  # GET /reports.xml
  def index
    @reports = Report.order('select_priority DESC,estimated_date')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.xml
  def show
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.xml
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Report was successfully created.'
        format.html { redirect_to(@report) }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    respond_to do |format|
      if @report.update_attributes(report_params)
        flash[:notice] = 'Report was successfully updated.'
        format.html { redirect_to(@report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end

  # tag a report
  #TODO add error flash
  def tag
    ReportsReporttag.create(:reporttag_id => params[:reporttag_id], :report_id => params[:report_id])
    flash[:notice] = "Tag added"
    redirect_to :action => :edit, :id => params[:report_id]
  end

  # untag a report
  #TODO add error flash
  def untag
    report=Report.find(params[:report_id])
    reporttag=Reporttag.find(params[:reporttag_id])
    report.reporttags.delete(reporttag)
#    ReportsReporttag.destroy_all({:reporttag_id => params[:reporttag_id],:report_id => params[:report_id]})
    flash[:notice] = "Tag removed"
    redirect_to :action => :edit, :id => params[:report_id]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:label, :description, :estimated_date, :select_priority)
  end

end
