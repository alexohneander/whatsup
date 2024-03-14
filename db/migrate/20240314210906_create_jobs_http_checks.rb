class CreateJobsHttpChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs_http_checks do |t|
      t.string :title
      t.boolean :active
      t.string :url
      t.string :valid_status
      t.integer :interval
      t.timestamps
    end
  end
end
