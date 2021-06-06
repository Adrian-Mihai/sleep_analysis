module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :first_name, :last_name, :name, :email

      def name
        "#{object.first_name} #{object.last_name}"
      end
    end
  end
end
