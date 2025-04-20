class Exposit::RetrieveBatchRequestJob < ApplicationJob
  queue_as :default

  def perform(batch_request_id)
    Rails.logger.info("Starting retrieval of batch request: #{batch_request_id}")
    service = ExpositionService.new
    batch_request = Exposition::BatchRequest.find(batch_request_id)
    batch_request = service.retrieve_batch(batch_request)
    retrieval_interval = 1.minute

    case batch_request.status
    when "requested"
      Rails.logger.info("Batch still in requested state, waiting for processing")
      Exposit::RetrieveBatchRequestJob.set(wait: retrieval_interval).perform_later(batch_request.id)
    when "validating"
      Rails.logger.info("Batch input file is being validated before the batch can begin")
      Exposit::RetrieveBatchRequestJob.set(wait: retrieval_interval).perform_later(batch_request.id)
    when "failed"
      Rails.logger.error("Batch input file has failed the validation process at #{batch_request.failed_at}")
    when "in_progress"
      Rails.logger.info("Batch input file was successfully validated at #{batch_request.in_progress_at} and the batch is currently being run")
      Rails.logger.info("#{batch_request.requested_completed_count} completed, #{batch_request.requested_failed_count} failed of #{batch_request.requested_total_count} total requests")
      Exposit::RetrieveBatchRequestJob.set(wait: retrieval_interval).perform_later(batch_request.id)
    when "finalizing"
      wait_time = [ batch_request.finalizing_at - Time.current, retrieval_interval ].max
      Rails.logger.info("Batch has completed and the results are being prepared, waiting for #{wait_time} seconds before retrying")
      Exposit::RetrieveBatchRequestJob.set(wait: wait_time).perform_later(batch_request.id)
    when "completed"
      Rails.logger.info("Batch has been completed at #{batch_request.completed_at} and the results are ready")
      Exposit::FetchBatchRequestContentsJob.perform_later(batch_request.id)
    when "expired"
      Rails.logger.error("Batch was not able to be completed within the 24-hour time window, expired at #{batch_request.expired_at}")
    when "cancelling"
      wait_time = [ batch_request.cancelling_at - Time.current, retrieval_interval ].max
      Rails.logger.warn("Batch will be cancelled at #{batch_request.cancelling_at}, waiting for #{wait_time} seconds before retrying")
      Exposit::RetrieveBatchRequestJob.set(wait: wait_time).perform_later(batch_request.id)
    when "cancelled"
      Rails.logger.warn("Batch was cancelled at #{batch_request.cancelled_at}")
    else
      Rails.logger.error("Unknown batch request status: #{batch_request.status}")
    end

    Rails.logger.info("Completed retrieval of batch request: #{batch_request.id}")
  rescue StandardError => e
    Rails.logger.error("Failed retrieval of batch request: #{batch_request_id} (#{e.message})")
    raise e
  end
end
