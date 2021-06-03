module ActiveRecord
  module LookML
    module Core
      extend ActiveSupport::Concern

      module ClassMethods
        def to_lookml(table_name_prefix: 'wantedly-1371.rdb.pulse_')
          fields = attribute_types.map do |attribute, type|
            attribute_type_to_set_detail_field(attribute, type)
          end.compact

          set_block = Block.new(type: "set", name: "detail") do |b|
            b << ArrayField.new(name: "fields", values: fields)
          end

          Block.new(type: "view", name: "pulse_onboarding_statuses") do |b|
            b << Field.new(name: "sql_table_name", value: "`#{table_name_prefix}#{table_name}`;;")
            attribute_types.each do |attribute, type|
              b << attribute_type_to_block(attribute, type)
            end
            b << set_block
          end.to_lookml
        end

        private
        def attribute_type_to_block(attribute, type)
          case type
          when ActiveModel::Type::Integer
            Block.new(type: "dimension", name: attribute) do |b|
              b << Field.new(name: "type", value: "number")
              b << Field.new(name: "primary_key", value: "yes") if attribute == "id"
              b << Field.new(name: "sql", value: "${TABLE}.#{attribute} ;;")
            end
          when ActiveModel::Type::Boolean
            Block.new(type: "dimension", name: attribute) do |b|
              b << Field.new(name: "type", value: "yesno")
              b << Field.new(name: "sql", value: "${TABLE}.#{attribute} ;;")
            end
          when ActiveModel::Type::String
            Block.new(type: "dimension", name: attribute) do |b|
              b << Field.new(name: "type", value: "string")
              b << Field.new(name: "sql", value: "${TABLE}.#{attribute} ;;")
            end
          when ActiveRecord::Type::DateTime, ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter
            Block.new(type: "dimension_group", name: attribute) do |b|
              b << Field.new(name: "type", value: "time")
              b << Field.new(name: "sql", value: "${TABLE}.#{attribute} ;;")
            end
          when ActiveRecord::Enum::EnumType
            # @see https://github.com/rails/rails/blob/master/activerecord/lib/active_record/enum.rb
            enum_values = defined_enums[attribute]

            Block.new(type: "dimension", name: attribute) do |b|
              b << Block.new(type: "case", name: nil) do |b|
                enum_values.map do |label, value|
                  b << Block.new(type: "when", name: nil) do |b|
                    b << Field.new(name: "sql", value: "${TABLE}.#{attribute} = #{value} ;;")
                    b << Field.new(name: "label", value: "\"#{label}\"")
                  end
                end
              end
            end
          else
            raise "Unknown attribute type: #{attribute} #{type.class}"
          end
        end

        def attribute_type_to_set_detail_field(attribute, type)
          case type
          when ActiveModel::Type::Integer, ActiveModel::Type::Boolean, ActiveRecord::Enum::EnumType
            attribute
          when ActiveRecord::Type::DateTime, ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter
            "#{attribute}_time"
          else
            raise "Unknown attribute type: #{attribute} #{type.class}"
          end
        end
      end
    end
  end
end
