class PulseOnboardingStatus < ActiveRecord::Base
  MANAGER_TUTORIAL_STATE_ENUM_HASH = {
    start_tutorial: 0,
    explain_condition_survey: 1,
    ask_condition: 2,
    explain_high_fives: 3,
    try_high_fives: 4,
    request_members_to_get_started: 5,
    done_announce_to_member: 6,
    done_tutorial: 7,
  }.freeze

  MEMBER_TUTORIAL_STATE_ENUM_HASH = {
    explain_condition_survey: 0,
    ask_condition: 1,
    explain_high_fives: 2,
    try_high_fives: 3,
    done_tutorial: 4,
  }.freeze

  enum manager_tutorial_state: MANAGER_TUTORIAL_STATE_ENUM_HASH, _prefix: true
  enum member_tutorial_state: MEMBER_TUTORIAL_STATE_ENUM_HASH, _prefix: true
end
