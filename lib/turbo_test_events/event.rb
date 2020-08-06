# frozen_string_literal: true

require "observer"

module TurboTest
  class Event
    include Observable

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
