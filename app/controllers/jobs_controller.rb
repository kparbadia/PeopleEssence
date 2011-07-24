class JobsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /jobs
  # GET /jobs.xml
  def index
    @jobs = current_user.matched_jobs

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end

  def result
    @friends = current_user.friends
    @jobs = []
    
    @friends_grouped_by_company =  @friends.group_by(){|friend| friend.employments.first.company}
    @friends_grouped_by_company.each do |company_name, friends|
      next if(company_name == 'No company found' )
      @job_vacancies = {}
      @job_vacancies[:search_result] = {}
      @job_vacancies[:company_name] = company_name
      @job_vacancies[:friends]      = friends      
      
      @job_vacancies[:search_result][:indeed]         = [] #JobVacancySearch.find_jobs_from_indeed(company_name, current_user)
      @job_vacancies[:search_result][:simply_hired] = [] #JobVacancySearch.find_jobs_from_simply_hired(company_name, current_user)
      @jobs << @job_vacancies
    end
  end

  def vacancies
    company_name = params[:company]

    @job = {}
    @job[:search_result] = {}
    @job[:company_name] = company_name
    if(company_name.present?)
      @job[:search_result][:indeed]       = JobVacancySearch.find_jobs_from_indeed(company_name, current_user)
      @job[:search_result][:simply_hired] = JobVacancySearch.find_jobs_from_simply_hired(company_name, current_user)
    else
      @job[:search_result][:indeed]       = []
      @job[:search_result][:simply_hired] = []
    end
  end
end
