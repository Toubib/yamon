class ReporttagsController < ApplicationController

  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update, :destroy]
  before_action :set_reporttag, only: [:destroy, :show, :edit, :update]

  # GET /reporttags
  # GET /reporttags.xml
  def index
    @reporttags = Reporttag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reporttags }
    end
  end

  # GET /reporttags/1
  # GET /reporttags/1.xml
  def show
  end

  # GET /reporttags/new
  # GET /reporttags/new.xml
  def new
    @reporttag = Reporttag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reporttag }
    end
  end

  # GET /reporttags/1/edit
  def edit
  end

  # POST /reporttags
  # POST /reporttags.xml
  def create
    @reporttag = Reporttag.new(reporttag_params)

    respond_to do |format|
      if @reporttag.save
        flash[:notice] = 'Reporttag was successfully created.'
        format.html { redirect_to(@reporttag) }
        format.xml  { render :xml => @reporttag, :status => :created, :location => @reporttag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reporttag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reporttags/1
  # PUT /reporttags/1.xml
  def update

    respond_to do |format|
      if @reporttag.update_attributes(reporttag_params)
        flash[:notice] = 'Reporttag was successfully updated.'
        format.html { redirect_to(@reporttag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reporttag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reporttags/1
  # DELETE /reporttags/1.xml
  def destroy
    @reporttag.destroy

    respond_to do |format|
      format.html { redirect_to(reporttags_url) }
      format.xml  { head :ok }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reporttag
    @reporttag = Reporttag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reporttag_params
    params.require(:reporttag).permit(:name, :description, :css_classes, :exclude_from_stats)
  end

end
