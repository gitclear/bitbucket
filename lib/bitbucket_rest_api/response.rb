# encoding: utf-8

require "faraday"

module BitBucket
  # Contains methods and attributes that act on the response returned from the
  # request
  class Response < Faraday::Middleware
    CONTENT_TYPE = "Content-Type".freeze

    class << self
      attr_accessor :parser
    end

    def self.define_parser(&block)
      @parser = block
    end

    # Replaces the behavior of Faraday 1.x's Faraday::Response::Middleware#on_complete,
    # which was removed in Faraday 2. Delegates to each subclass's parse method
    # for all non-nil bodies, letting the parser decide how to handle edge cases
    # (e.g., Jsonize/Xmlize map "" to nil).
    def on_complete(env)
      env[:body] = parse(env[:body]) if respond_to?(:parse, true) && !env[:body].nil?
    end

    def response_type(env)
      env[:response_headers][CONTENT_TYPE].to_s
    end

  end
end
