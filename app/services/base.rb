class Base
  attr_reader :errors

  def valid?
    @errors.empty?
  end

  protected

  def initialize
    @errors = []
  end

  def user
    return @user if defined? @user

    @user = User.find(@user_id)
  end
end
