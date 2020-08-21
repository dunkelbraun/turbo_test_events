# frozen_string_literal: true

require "singleton"
require "forwardable"
require "concurrent"

module TurboTest
  class EventRegistry
    include Singleton

    def initialize
      @events = Concurrent::Map.new
    end

    def register(event_name)
      @events[event_name] ||= Event.new
    end
    alias [] register

    class << self
      extend Forwardable
      def_delegators :instance, :register, :[]

      # :nocov:
      remove_method :instance if RUBY_VERSION < "2.7"
      # :nocov:

      private

      def instance
        @instance || Mutex.new.synchronize { @instance ||= new }
      end
    end
  end
end
