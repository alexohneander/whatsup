class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        @job_count = Jobs::HttpCheck.where(user_id: current_user.id).count
    end
end
