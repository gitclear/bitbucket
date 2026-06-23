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

    # Replaces the behavior of Faraday 1.x's Faraday::Response::Middleware#on_complete, which was removed in Faraday 2.
    # Matches its original logic: call parse when body is non-nil and not an empty string.
    def on_complete(env)
      body = env[:body]
      if respond_to?(:parse, true) && !body.nil? && !(body.respond_to?(:to_str) && body.empty?)
        env[:body] = parse(body)
      end
    end

    def response_type(env)
      env[:response_headers][CONTENT_TYPE].to_s
    end

  end
end
