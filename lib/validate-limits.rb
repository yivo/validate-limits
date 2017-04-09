# encoding: UTF-8
# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/lazy_load_hooks'

module ValidateLimits
  module Extension
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes_with_limit_validation, instance_accessor: false, instance_predicate: false
      class_eval { self.attributes_with_limit_validation = [] }
    end

    module ClassMethods
      def inherited(cls)
        super.tap { cls.validate_limits }
      end

      def validate_limits
        return if defined?(ActiveRecord::SchemaMigration) && self <= ActiveRecord::SchemaMigration
        return if abstract_class?
        return remove_instance_variable(:@table_name) unless table_name.in?(ActiveRecord::Base.connection.tables)

        columns_hash.values.each do |column|
          next if attributes_with_limit_validation.include?(column.name)

          case column.type
            when :string, :text
              self.attributes_with_limit_validation += [column.name]
              validates_length_of column.name, maximum: column.limit

            when :integer
              next if column.name == primary_key

              self.attributes_with_limit_validation += [column.name]
              bits = column.limit * 8
              min  = -(2**(bits-1))
              max  = +(2**(bits-1))-1
              validates_numericality_of column.name, greater_than_or_equal_to: min,
                                                     less_than_or_equal_to:    max,
                                                     if:                       "#{column.name}?"
          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) { ActiveRecord::Base.include ValidateLimits::Extension }
