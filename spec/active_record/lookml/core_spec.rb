require 'models/pulse_onboarding_status'

RSpec.describe ActiveRecord::LookML::Core do
  it "adds .to_lookml method to ActiveRecord::Base" do
    expect(ActiveRecord::Base.respond_to?(:to_lookml)).to be_truthy
  end

  describe ".to_lookml" do
    let(:lookml) do
      <<-LOOKML
view: pulse_onboarding_statuses {
  sql_table_name: `wantedly-1371.rdb.pulse_pulse_onboarding_statuses`;;

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}.company_id ;;
  }

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

  dimension: completed {
    type: yesno
    sql: ${TABLE}.completed ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}.updated_at ;;
  }

  set: detail {
    fields: [
      id,
      user_id,
      company_id,
      manager_tutorial_state,
      member_tutorial_state,
      completed,
      created_at_time,
      updated_at_time
    ]
  }
}
      LOOKML
    end

    it "returns lookml" do
      expect(PulseOnboardingStatus.to_lookml).to eq lookml
    end
  end
end
