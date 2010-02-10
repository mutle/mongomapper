module MongoMapper
  module Plugins
    module Validations
      def self.configure(model)
        model.class_eval do
          include ActiveModel::Validations
        end
      end
      
      module DocumentMacros
        def validates_uniqueness_of(*attr_names)
          validates_with UniquenessValidator, _merge_attributes(attr_names)
        end
      end
      
      class UniquenessValidator < ActiveModel::EachValidator
        def initialize(options)
          super(options.reverse_merge(:allow_blank => true, :allow_nil => true, :case_sensitive => true))
        end
   
        def validate_each(record, attribute, value)
          return if options[:allow_blank] && value.blank?
          return if options[:allow_nil] && value.nil?
          base_conditions = options[:case_sensitive] ? {attribute => value} : {}
          doc = record.class.first(base_conditions.merge(scope_conditions(record)).merge(where_conditions(record, attribute)))
          unless doc.nil? || record._id == doc._id
            record.errors.add(attribute, :taken, :default => options[:message])
          end
        end
        
        def scope_conditions(record)
          return {} unless options[:scope]
          Array(scope).inject({}) do |conditions, key|
            conditions.merge(key => record[key])
          end
        end

        def where_conditions(record, attribute)
          conditions = {}
          conditions[attribute] = /#{record[attribute].to_s}/i unless options[:case_sensitive]
          conditions
        end
      end
    end
  end
end
