class Exposit::FetchBatchRequestContentsJob < ApplicationJob
  queue_as :default

  def perform(batch_request_id)
    Rails.logger.info("Starting fetching contents of batch request: #{batch_request_id}")
    service = ExpositionService.new
    batch_request = Exposition::BatchRequest.find(batch_request_id)
    exposition_contents = service.batch_file_content(batch_request)
    exposition_contents.each do |exposition_content|
      Rails.logger.info("Created exposition content #{exposition_content.id} from batch request: #{batch_request.id}")
    end
    Rails.logger.info("Completed fetching contents of batch request: #{batch_request.id}")
  rescue StandardError => e
    Rails.logger.error("Failed fetching contents of batch request: #{batch_request_id} (#{e.message})")
    raise e
  end
end
