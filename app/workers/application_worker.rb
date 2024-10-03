class ApplicationWorker
  include Sidekiq::Worker

  def perform(*args)
    execute(*args)
  rescue StandartError => e
    handle_error(e)
  end

  private

  def handle_error(exception)
    logger.error("Error performing job: #{exception.message}")
  end
end