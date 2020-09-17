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

### ActiveRecord::Enum

Suppose you have ActiveRecord class with enum as below.

```ruby
class PulseOnboardingStatus < ApplicationRecord
  MEMBER_TUTORIAL_STATE_ENUM_HASH = {
    explain_condition_survay: 0,
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
$ ./bin/rails c

> puts PulseOnboardingStatus.enum_to_lookml

  dimension: member_tutorial_state {
    case: {
        when: {
        sql: ${TABLE}.member_tutorial_state = 0 ;;
        label: "explain_condition_survay"
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
