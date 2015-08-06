module CoreExtensions
  module Mongoid
    module Attributes
      extend ActiveSupport::Concern

      class_methods do
        def alias_underscored_attributes
          attribute_names.each do |attribute_name|
            alias_attribute attribute_name.underscore, attribute_name
          end
        end
      end
    end
  end
end
