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
end
