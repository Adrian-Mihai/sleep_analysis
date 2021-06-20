class Base
  attr_reader :errors

  def valid?
    @errors.empty?
  end

  protected

  def initialize
    @errors = []
  end
end
