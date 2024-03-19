class Jobs::HttpChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jobs_http_check, only: %i[ show edit update destroy ]

  # GET /jobs/http_checks or /jobs/http_checks.json
  def index
    @jobs_http_checks = Jobs::HttpCheck.all
  end

  # GET /jobs/http_checks/1 or /jobs/http_checks/1.json
  def show
    @jobs_http_check = Jobs::HttpCheck.find(params[:id])
  end

  # GET /jobs/http_checks/new
  def new
    @jobs_http_check = Jobs::HttpCheck.new
  end

  # GET /jobs/http_checks/1/edit
  def edit
  end

  # POST /jobs/http_checks or /jobs/http_checks.json
  def create
    @jobs_http_check = Jobs::HttpCheck.new(jobs_http_check_params)

    respond_to do |format|
      if @jobs_http_check.save
        # Add new CronJob with interval
        add_http_check_job_to_queue(@jobs_http_check)

        format.html { redirect_to jobs_http_check_url(@jobs_http_check), notice: "Http check was successfully created." }
        format.json { render :show, status: :created, location: @jobs_http_check }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jobs_http_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/http_checks/1 or /jobs/http_checks/1.json
  def update
    respond_to do |format|
      if @jobs_http_check.update(jobs_http_check_params)
        # Update Job with interval
        update_http_check_job_in_queue(@jobs_http_check)

        format.html { redirect_to jobs_http_check_url(@jobs_http_check), notice: "Http check was successfully updated." }
        format.json { render :show, status: :ok, location: @jobs_http_check }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jobs_http_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/http_checks/1 or /jobs/http_checks/1.json
  def destroy
    # Remove Job from queue
    delete_http_check_job_in_queue(@jobs_http_check)
    @jobs_http_check.destroy!

    respond_to do |format|
      format.html { redirect_to jobs_http_checks_url, notice: "Http check was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jobs_http_check
      @jobs_http_check = Jobs::HttpCheck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jobs_http_check_params
      params.require(:jobs_http_check).permit(:id, :title, :active, :public, :url, :valid_status, :interval)
    end

    # Add Job to queue 
    def add_http_check_job_to_queue(http_check)
      is_check_active = http_check.active ? "enabled" : "disabled"
      job_name = "HTTP Check - #{http_check.id}"

      job = Sidekiq::Cron::Job.new(
        name: job_name,
        namespace: 'HttpChecks',
        cron: "*/#{http_check.interval} * * * *",
        class: 'HttpCheckJob',
        args: http_check
      )

      if job.valid?
        logger.info("Job is valid")
        if http_check.active
          job.enable!
        else
          job.disable!
        end

        job.save
      else
        logger.error(job.errors)
      end
    end

    # Update Job
    def update_http_check_job_in_queue(http_check)
      job_name = "HTTP Check - #{http_check.id}"
      job = Sidekiq::Cron::Job.find(job_name)

      if job.valid?
        logger.info("Job is valid")
        job.cron = "*/#{http_check.interval} * * * *"
        job.args = http_check

        if http_check.active
          job.enable!
        else
          job.disable!
        end

        job.save
      else
        logger.error(job.errors)
      end
    end

    # Remove Job from queue
    def delete_http_check_job_in_queue(http_check)
      begin
        job_name = "HTTP Check - #{http_check.id}"
        job = Sidekiq::Cron::Job.find(job_name)

        job.destroy
      rescue => e
        logger.error(e)
      end
    end
end
