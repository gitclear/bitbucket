# encoding: utf-8

require "faraday"
require "base64"

module BitBucket
  module Request
    class BasicAuth < Faraday::Middleware
      def call(env)
        env[:request_headers].merge!("Authorization" => "Basic #{ @auth }\"")

        @app.call env
      end

      def initialize(app, *args)
        @app = app
        credentials = ""
        options = args.extract_options!
        if options.key?(:login)
          credentials = "#{ options[:login] }:#{ options[:password] }"
        elsif options.key?(:basic_auth)
          credentials = options[:basic_auth].to_s
        end
        @auth = Base64.encode64(credentials)
        @auth.gsub!("\n", "")
      end
    end
  end
end
