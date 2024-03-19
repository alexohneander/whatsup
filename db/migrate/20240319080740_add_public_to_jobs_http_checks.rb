class AddPublicToJobsHttpChecks < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs_http_checks, :public, :boolean, :default => false
  end
end
