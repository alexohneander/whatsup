# CleanUp CronJobs
# jobs = Sidekiq::Cron::Job.all
# jobs.each do |job|
#     job.destroy
# end

# Create daily job
# Sidekiq::Cron::Job.create(
#     name: 'Import Cards - every day at 1am',
#     cron: '* * * * *',
#     namespace: 'CronJobs',
#     class: 'Import::CardsJob'
# )%