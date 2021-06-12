class DelayedServiceCall < ApplicationJob
  def perform(service_name, **params)
    service = service_name.safe_constantize
    return if service.nil?

    service.new(params).perform
  end
end
