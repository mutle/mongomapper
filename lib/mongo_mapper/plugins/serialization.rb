require 'active_support/json'

module MongoMapper
  module Plugins
    module Serialization
      def self.configure(model)
        model.class_eval {
          include ActiveModel::Serializers::JSON
        }
      end
    end
  end
end
