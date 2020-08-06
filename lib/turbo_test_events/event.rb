# frozen_string_literal: true

require "observer"

module TurboTest
  class Event
    include Observable

    def publish(*arg)
      changed
      notify_observers(*arg)
    end

    alias subscribe_without_locking add_observer
    undef :add_observer

    def subscribe(subscriber, func=:update)
      Mutex.new.synchronize { subscribe_without_locking(subscriber, func) }
    end

    alias unsubscribe_without_locking delete_observer
    undef :delete_observer

    def unsubscribe(subscriber)
      Mutex.new.synchronize { unsubscribe_without_locking(subscriber) }
    end

    alias unsubscribe_all_without_locking delete_observers
    undef :delete_observers

    def unsubscribe_all
      Mutex.new.synchronize { unsubscribe_all_without_locking }
    end
  end
end
