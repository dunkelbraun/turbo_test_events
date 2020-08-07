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

    def update_frozen(payload)
      raise StandardError if payload.frozen?
    end
  end

  test "subscribing to an event" do
    event = TurboTest::Event.new
    observer_one = Observer.new(1)
    observer_two = Observer.new(2)
    event.subscribe(observer_one)
    event.subscribe(observer_two)

    observer_peers = event.instance_variable_get(:@observer_peers).keys
    assert_equal 2, observer_peers.length
    assert_equal observer_one, observer_peers.first
    assert_equal observer_two, observer_peers.last
  end

  test "#add_observer is not defined" do
    event = TurboTest::Event.new
    assert_raises NoMethodError do
      event.add_observer(Observer.new(1))
    end
  end

  test "unsubscribing from an event" do
    event = TurboTest::Event.new
    observer_one = Observer.new(1)
    observer_two = Observer.new(2)
    event.subscribe(observer_one)
    event.subscribe(observer_two)

    event.unsubscribe(observer_one)

    observer_peers = event.instance_variable_get(:@observer_peers).keys
    assert_equal 1, observer_peers.length
    assert_equal observer_two, observer_peers.first
  end

  test "#delete_observer is not defined" do
    event = TurboTest::Event.new
    observer = Observer.new(1)
    event.subscribe(observer)

    assert_raises NoMethodError do
      event.delete_observer(observer)
    end
  end

  test "unsubscribing all observers from an event" do
    event = TurboTest::Event.new
    observer_one = Observer.new(1)
    observer_two = Observer.new(2)
    event.subscribe(observer_one)
    event.subscribe(observer_two)

    event.unsubscribe_all

    observer_peers = event.instance_variable_get(:@observer_peers).keys
    assert_equal 0, observer_peers.length
  end

  test "#delete_observers is not defined" do
    event = TurboTest::Event.new

    assert_raises NoMethodError do
      event.delete_observers
    end
  end

  test "publish an event notifies the observers" do
    event = TurboTest::Event.new
    event.subscribe(Observer.new(1))
    event.subscribe(Observer.new(2))
    event.subscribe(Observer.new(3))

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

  test "event payload is frozen" do
    event = TurboTest::Event.new
    event.subscribe(Observer.new(1), :update_frozen)
    assert_raises StandardError do
      event.publish([1, 2, 3, 4])
    end
  end
end
