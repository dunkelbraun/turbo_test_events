# frozen_string_literal: true

require "test_helper"

describe "TurboTest::EventRegistry" do
  let(:event_registry) { TurboTest::EventRegistry }

  before do
    event_registry.instance_variable_set(:@instance, nil)
  end

  test "register events" do
    event = event_registry.register("event_1")
    assert_instance_of TurboTest::Event, event
    assert_equal "event_1", event.name
  end

  test "register event without name raises exception" do
    assert_raises(ArgumentError) do
      event_registry.register(nil)
    end
  end

  test "accessing events" do
    event_one = event_registry.register("event_1")
    event_two = event_registry.register("event_2")

    assert_equal event_one, event_registry["event_1"]
    assert_equal event_two, event_registry["event_2"]
  end

  test "registering the same event multiple times only creates one event" do
    TurboTest::Event.expects(:new).once.returns(mock)
    events = 5.times.collect { event_registry.register("event_1") }

    assert_equal events.first.object_id, event_registry["event_1"].object_id
  end

  class SubscriberTouch
    attr_reader :events

    def initialize(name)
      @name = name
      @events = []
    end

    def update(payload)
      Mutex.new.synchronize do
        @events << payload
      end
    end
  end

  test "events in threads" do
    event = event_registry.register("event_1")
    threads = []

    subscriber_thread_one = Thread.new do
      subscriber = SubscriberTouch.new("subs_one")
      event.subscribe(subscriber)
    end
    threads << subscriber_thread_one

    subscriber_thread_two = Thread.new do
      subscriber = SubscriberTouch.new("subs_two")
      event.subscribe(subscriber)
    end
    threads << subscriber_thread_two

    threads.each(&:join)

    observer_peers = event.instance_variable_get(:@observer_peers)
    assert_equal 2, observer_peers.size

    threads = []
    2.times do |n|
      threads << Thread.new do
        event.publish(n)
      end
    end

    threads.each(&:join)

    observer_peers.each do |observer_peer|
      assert_equal [0,1], observer_peer.events.sort
    end
  end
end
