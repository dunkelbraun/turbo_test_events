![Tests](https://github.com/dunkelbraun/turbo_test_events/workflows/Tests/badge.svg?branch=main)
[![Maintainability](https://api.codeclimate.com/v1/badges/cdac75678956e034e298/maintainability)](https://codeclimate.com/github/dunkelbraun/turbo_test_events/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/dunkelbraun/turbo_test_events/badge.svg?branch=main)](https://coveralls.io/github/dunkelbraun/turbo_test_events?branch=main)

# TurboTestEvents

TurboTestEvents is a minimal event framework for Ruby based on Observable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'turbo_test_events'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install turbo_test_events

## Usage

### Publish an event

```ruby
payload = {created_at: Time.now}
TurboTest::EventRegistry["event_1"].publish(payload)
```

### Subscribe to an event

Implement subscriber class with the update callback method:

```ruby
class Subscriber
  def update(event_payload)
    # Process event
  end
end
```

Create a subscriber and subscribe it to the event:

```ruby
subscriber = Subscriber.new
TurboTest::EventRegistry["event_1"].subscribe(subscriber)
```

You can have a custom update callback method with: 

```ruby
TurboTest::EventRegistry["event_1"].subscribe(subscriber, :method_name)

class CustomSubscriber
  def method_name(event_payload)
    # Process event
  end
end
```

### Unsubscribe from an event

```ruby
TurboTest::EventRegistry["event_1"].unsubscribe(subscriber)
```

### Unsubscribe all subscribers from an event

```ruby
TurboTest::EventRegistry["event_1"].unsubscribe_all
```


## Multithreading Notes
  - You can publish events from different threads.
  - You can add and remove subscribers in different threads.
  - There are no guarantees about the thread that will execute the subscriber callback.
  - You should synchronize any internal data of the subscriber when modifying it.
  - You should synchronize any data of the event payload when modifying it.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dunkelbraun/turbo_test_events. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dunkelbraun/turbo_test_events/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TurboTestEvents project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dunkelbraun/turbo_test_events/blob/master/CODE_OF_CONDUCT.md).
