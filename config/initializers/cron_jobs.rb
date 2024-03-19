Rails.configuration.after_initialize do
    # Get all http_checks and add them to the queue
    begin
        http_checks = Jobs::HttpCheck.all

        http_checks.each { |http_check|
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
                puts "Job is valid"
                if http_check.active
                    job.enable!
                else
                    job.disable!
                end

                job.save
            else
                puts job.errors
            end
        }
    rescue => e
        puts e
    end
end