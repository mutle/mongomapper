module MongoMapper
  module Plugins
    module Callbacks
      CALLBACKS = [ :save, :create, :update, :validation, :validation_on_create, :validation_on_update, :destroy ]
      def self.configure(model)
        model.class_eval do
          extend ActiveModel::Callbacks
          define_model_callbacks *CALLBACKS
        end
      end
      
      module InstanceMethods
        def valid?
          action = new? ? 'create' : 'update'
          result = nil

          run_callbacks(:validation) do
            run_callbacks("validation_on_#{action}".to_sym) do
              result = super
            end
          end

          result
        end

        def destroy
          result = nil
          run_callbacks(:destroy) do
            result = super
          end
          result
        end

        private
          def create_or_update(*args)
            result = nil
            run_callbacks(:save) do
              # if result = super
              #   run_callbacks(:_save)
              # end
              result = super
            end
            result
          end

          def create(*args)
            result = nil
            run_callbacks(:create) do
              result = super
            end
            result
          end

          def update(*args)
            result = nil
            run_callbacks(:update) do
              result = super
            end
            result
          end
      end
    end
  end
end
