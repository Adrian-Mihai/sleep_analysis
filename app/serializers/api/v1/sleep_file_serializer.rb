module Api
  module V1
    class SleepFileSerializer < ActiveModel::Serializer
      attributes :id, :filename, :status

      def filename
        object.file.filename.to_s
      end
    end
  end
end
