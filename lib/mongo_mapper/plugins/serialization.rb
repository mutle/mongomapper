require 'active_support/json'

module MongoMapper
  module Plugins
    module Serialization
      def self.configure(model)
        model.class_eval { include Json }
      end
      
      module Json
        def self.included(base)
          base.send :include, ActiveModel::Serializers::JSON
        end
      end
    end
  end
end
