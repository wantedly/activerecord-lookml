module ActiveRecord
  module LookML
    module Core
      extend ActiveSupport::Concern

      module ClassMethods
        # Generates LookML dimension from ruby hash.
        #
        # Input format:
        #
        # {"manager_tutorial_state"=>
        #   {"start_tutorial"=>0,
        #    "explain_condition_survay"=>1,
        #    "ask_condition"=>2,
        #    "explain_high_fives"=>3,
        #    "try_high_fives"=>4,
        #    "request_members_to_get_started"=>5,
        #    "done_announce_to_member"=>6,
        #    "done_tutorial"=>7}}
        #
        #
        # Output format:
        #
        # dimension: manager_tutorial_state {
        #   case: {
        #       when: {
        #       sql: ${TABLE}.manager_tutorial_state = 0 ;;
        #       label: "start_tutorial"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 1 ;;
        #       label: "explain_condition_survay"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 2 ;;
        #       label: "ask_condition"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 3 ;;
        #       label: "explain_high_fives"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 4 ;;
        #       label: "try_high_fives"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 5 ;;
        #       label: "request_members_to_get_started"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 6 ;;
        #       label: "done_announce_to_member"
        #     }
        #     when: {
        #       sql: ${TABLE}.manager_tutorial_state = 7 ;;
        #       label: "done_tutorial"
        #     }
        #   }
        # }
        # @see https://github.com/rails/rails/blob/master/activerecord/lib/active_record/enum.rb
        def enum_to_lookml
          defined_enums.map do |name, enum_values|
            when_lines_lookml = enum_values.map do |label, value|
              <<-LOOKML
      when: {
        sql: ${TABLE}.#{name} = #{value} ;;
        label: "#{label}"
      }
              LOOKML
            end.join

            <<-LOOKML
  dimension: #{name} {
    case: {
  #{when_lines_lookml}
    }
  }
            LOOKML
          end.join("\n")
        end

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
          when ActiveRecord::Type::DateTime, ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter
            Block.new(type: "dimension_group", name: attribute) do |b|
              b << Field.new(name: "type", value: "time")
              b << Field.new(name: "sql", value: "${TABLE}.#{attribute} ;;")
            end
          when ActiveRecord::Enum::EnumType
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
