class AddUserIdToJobsHttpChecks < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs_http_checks, :user_id, :integer
  end
end
