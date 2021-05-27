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
      end
    end
  end
end