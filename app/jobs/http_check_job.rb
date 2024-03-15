class HttpCheckJob < ApplicationJob
  queue_as :default

  def perform(http_check)
    check = Jobs::HttpCheck.find_by(id: http_check.id)

    begin
      response = Faraday.get(check.url)
      if response.status == http_check.valid_status
        check.status = "up"
      else
        check.status = "down"
      end
    rescue => e
      logger.error(e)
      check.status = "down"
    end

    check.count_checks = check.count_checks + 1
    check.save
  end
end
