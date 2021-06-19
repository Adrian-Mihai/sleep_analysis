class ServiceError < StandardError
  attr_reader :service

  def initialize(service = nil)
    if service
      @service = service
      message = service.errors.join(', ')
    else
      message = 'Service invalid'
    end
    super(message)
  end
end
