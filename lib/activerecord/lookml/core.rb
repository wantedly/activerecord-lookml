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
        #    "done_tutorial"=>7},
        #  "member_tutorial_state"=>
        #   {"explain_condition_survay"=>0,
        #    "ask_condition"=>1,
        #    "explain_high_fives"=>2,
        #    "try_high_fives"=>3,
        #    "done_tutorial"=>4}}
        #
        #
        # Output format:
        #
        # dimension: status {
        #   case: {
        #     when: {
        #       sql: ${TABLE}.status = 0 ;;
        #       label: "active"
        #     }
        #     when: {
        #       sql: ${TABLE}.status = 1 ;;
        #       label: "deactivated"
        #     }
        #     when: {
        #       sql: ${TABLE}.status = 2 ;;
        #       label: "invited_by_admin"
        #     }
        #     when: {
        #       sql: ${TABLE}.status = 3 ;;
        #       label: "requested_by_member"
        #     }
        #   }
        # }
        #
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
