# frozen_string_literal: true

require "test_helper"

describe "TurboTest::Event" do
  class Observer
    def initialize(num)
      @num = num
    end

    def update(payload)
      File.open("tmp/event_1.observer_#{@num}", "w+") do |file|
        file.write payload.to_s
      end
    end
  end

  test "publish an event notifies the observers" do
    event = TurboTest::Event.new
    event.add_observer(Observer.new(1))
    event.add_observer(Observer.new(2))
    event.add_observer(Observer.new(3))

    event.publish("something")
    assert_equal "something", File.read("tmp/event_1.observer_1")
    assert_equal "something", File.read("tmp/event_1.observer_2")
    assert_equal "something", File.read("tmp/event_1.observer_3")

    event.publish(a: 1, b: 2)
    assert_equal({ a: 1, b: 2 }.to_s, File.read("tmp/event_1.observer_1"))
    assert_equal({ a: 1, b: 2 }.to_s, File.read("tmp/event_1.observer_2"))
    assert_equal({ a: 1, b: 2 }.to_s, File.read("tmp/event_1.observer_3"))

    event.publish([1, 2, 3, 4])
    assert_equal [1, 2, 3, 4].to_s, File.read("tmp/event_1.observer_1")
    assert_equal [1, 2, 3, 4].to_s, File.read("tmp/event_1.observer_2")
    assert_equal [1, 2, 3, 4].to_s, File.read("tmp/event_1.observer_3")
  end
end
