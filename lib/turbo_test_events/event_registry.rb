# frozen_string_literal: true

require "singleton"
require "forwardable"
require "concurrent"

module TurboTest
  class EventRegistry
    include Singleton

    @instance = nil

    def initialize
      @events = Concurrent::Map.new
    end

    def register(event_name)
      raise ArgumentError if event_name.nil?

      @events[event_name] ||= Event.new(event_name)
    end
    alias [] register

    class << self
      extend Forwardable
      def_delegators :instance, :register, :[]

      private

      # :nocov:
      remove_method :instance if RUBY_VERSION < "2.7"
      # :nocov:

      def instance
        @instance || Mutex.new.synchronize { @instance ||= new }
      end
    end
  end
end
