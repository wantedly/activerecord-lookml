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

        def to_lookml
          dimensions_lookml = attribute_types.map do |attribute, type|
            attribute_type_to_dimension_lookml(attribute, type)
          end.join("\n")

          fields = attribute_types.map do |attribute, type|
            attribute_type_to_set_detail_field(attribute, type)
          end.compact
          fields_lookml = fields.map { |field| "      #{field}" }.join(",\n")

          set_lookml = <<-LOOKML
  set: detail {
    fields: [
#{fields_lookml}
    ]
  }
          LOOKML

          <<-LOOKML
view: pulse_onboarding_statuses {
  sql_table_name: `wantedly-1371.rdb.pulse_pulse_onboarding_statuses`;;

#{dimensions_lookml}

#{set_lookml}
}
          LOOKML
        end

        private
        def attribute_type_to_dimension_lookml(attribute, type)
          case type
          when ActiveModel::Type::Integer
            primary_key_lookml = attribute == "id" ? "primary_key: yes" : nil

            <<-LOOKML
  dimension: #{attribute} {
    type: number
    #{primary_key_lookml}
    sql: ${TABLE}.#{attribute} ;;
  }
            LOOKML
          when ActiveModel::Type::Boolean
            <<-LOOKML
  dimension: #{attribute} {
    type: yesno
    sql: ${TABLE}.#{attribute} ;;
  }
            LOOKML
          when ActiveRecord::Type::DateTime
            <<-LOOKML
  dimension_group: #{attribute} {
    type: time
    sql: ${TABLE}.#{attribute} ;;
  }
            LOOKML
          when ActiveRecord::Enum::EnumType
            enum_values = defined_enums[attribute]
            when_lines_lookml = enum_values.map do |label, value|
              <<-LOOKML
      when: {
        sql: ${TABLE}.#{attribute} = #{value} ;;
        label: "#{label}"
      }
              LOOKML
            end.join

            <<-LOOKML
  dimension: #{attribute} {
    case: {
#{when_lines_lookml}
    }
  }
            LOOKML
          else
            raise "Unknown attribute type: #{type.class}"
          end
        end

        def attribute_type_to_set_detail_field(attribute, type)
          case type
          when ActiveModel::Type::Integer, ActiveModel::Type::Boolean, ActiveRecord::Enum::EnumType
            attribute
          when ActiveRecord::Type::DateTime
            "#{attribute}_time"
          else
            raise "Unknown attribute type: #{type.class}"
          end
        end
      end
    end
  end
end
