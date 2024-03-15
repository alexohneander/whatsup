class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        @job_count = Jobs::HttpCheck.all.count
    end
end
