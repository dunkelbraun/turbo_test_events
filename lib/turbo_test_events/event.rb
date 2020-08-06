# frozen_string_literal: true

require "observer"

module TurboTest
  class Event
    include Observable

    def publish(*arg)
      changed
      notify_observers(*arg)
    end
  end
end
