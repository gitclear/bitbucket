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

    # Replaces the automatic parse/parse_response? behavior that was built into
    # `Faraday::Response::Middleware` in Faraday 1.x.
    # The Faraday 2.x base class (Faraday::Middleware) only provides on_complete as a hook,
    # so subclasses (Jsonize, Mashify, Xmlize) need this to have their parse methods called.
    def on_complete(env)
      env[:body] = parse(env[:body]) if respond_to?(:parse, true) && parse_response?(env)
    end

    def response_type(env)
      env[:response_headers][CONTENT_TYPE].to_s
    end

    def parse_response?(env)
      env[:body].respond_to? :to_str
    end

  end
end
