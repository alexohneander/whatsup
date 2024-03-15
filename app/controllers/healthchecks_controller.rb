class HealthchecksController < ApplicationController
    def status
        if is_redis_connectable 
            @status = "ok"
        else
            @status = "failed"
        end
    end 

    private
    def is_redis_connectable
        return true
    end
end
