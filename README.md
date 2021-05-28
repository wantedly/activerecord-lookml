# ActiveRecord::LookML

This gem is ActiveRecord extension for LookML (Looker).



## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'activerecord-lookml'
end
```

## Usage

### Generate LookML view from ActiveRecord class

Suppose you have ActiveRecord class as below:

```ruby
ActiveRecord::Schema.define(version: 2021_05_26_103300) do
  create_table "pulse_onboarding_statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.integer "member_tutorial_state"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
```

```ruby
class PulseOnboardingStatus < ActiveRecord::Base
  MEMBER_TUTORIAL_STATE_ENUM_HASH = {
    explain_condition_survey: 0,
    ask_condition: 1,
    explain_high_fives: 2,
    try_high_fives: 3,
    done_tutorial: 4,
  }.freeze

  enum member_tutorial_state: MEMBER_TUTORIAL_STATE_ENUM_HASH, _prefix: true
end
```

You can generate LookML dimension as below.

```
> puts PulseOnboardingStatus.to_lookml
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
      member_tutorial_state,
      completed,
      created_at_time,
      updated_at_time
    ]
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wantedly/activerecord-lookml. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/wantedly/activerecord-lookml/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activerecord::Lookml project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wantedly/activerecord-lookml/blob/master/CODE_OF_CONDUCT.md).
