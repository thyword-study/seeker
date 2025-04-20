class Exposit::ProcessBatchRequestJob < ApplicationJob
  queue_as :default

  def perform(batch_request_id)
    Rails.logger.info("Starting processing of batch request: #{batch_request_id}")
    service = ExpositionService.new
    batch_request = Exposition::BatchRequest.find(batch_request_id)
    batch_request = service.upload_batch_file(batch_request)
    batch_request = service.create_batch(batch_request)
    Exposit::RetrieveBatchRequestJob.perform_later(batch_request.id)
    Rails.logger.info("Completed processing of batch request: #{batch_request.id}")
  rescue StandardError => e
    Rails.logger.error("Failed processing of batch request: #{batch_request_id} (#{e.message})")
    raise e
  end
end
