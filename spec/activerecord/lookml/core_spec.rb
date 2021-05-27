require 'models/pulse_onboarding_status'

RSpec.describe ActiveRecord::LookML::Core do
  it "adds .enum_to_lookml method to ActiveRecord::Base" do
    expect(ActiveRecord::Base.enum_to_lookml).to eq ""
  end

  describe ".enum_to_lookml" do
    let(:lookml) do
      <<-LOOKML
  dimension: manager_tutorial_state {
    case: {
        when: {
        sql: ${TABLE}.manager_tutorial_state = 0 ;;
        label: "start_tutorial"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 1 ;;
        label: "explain_condition_survey"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 2 ;;
        label: "ask_condition"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 3 ;;
        label: "explain_high_fives"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 4 ;;
        label: "try_high_fives"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 5 ;;
        label: "request_members_to_get_started"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 6 ;;
        label: "done_announce_to_member"
      }
      when: {
        sql: ${TABLE}.manager_tutorial_state = 7 ;;
        label: "done_tutorial"
      }

    }
  }

  dimension: member_tutorial_state {
    case: {
        when: {
        sql: ${TABLE}.member_tutorial_state = 0 ;;
        label: "explain_condition_survey"
      }
      when: {
        sql: ${TABLE}.member_tutorial_state = 1 ;;
        label: "ask_condition"
      }
      when: {
        sql: ${TABLE}.member_tutorial_state = 2 ;;
        label: "explain_high_fives"
      }
      when: {
        sql: ${TABLE}.member_tutorial_state = 3 ;;
        label: "try_high_fives"
      }
      when: {
        sql: ${TABLE}.member_tutorial_state = 4 ;;
        label: "done_tutorial"
      }

    }
  }
      LOOKML
    end

    it "returns partial lookml defining dimensions for enum attributes" do
      expect(PulseOnboardingStatus.enum_to_lookml).to eq lookml
    end
  end
end
