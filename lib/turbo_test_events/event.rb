# frozen_string_literal: true

require "observer"
require "concurrent"

module TurboTest
  class Event
    include Observable

    attr_reader :name

    def initialize(name = nil)
      @name = name
      @observer_peers = Concurrent::Map.new
    end

    def publish(*arg)
      changed
      notify_observers(*arg)
    end

    alias subscribe add_observer
    undef :add_observer

    alias unsubscribe delete_observer
    undef :delete_observer

    alias unsubscribe_all delete_observers
    undef :delete_observers
  end
end
