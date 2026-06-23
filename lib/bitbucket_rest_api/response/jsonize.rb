# encoding: utf-8

require "faraday"
require "multi_json"

module BitBucket
  class Response::Jsonize < Response

    define_parser do |body|
      if MultiJson.respond_to?(:load)
        MultiJson.load body
      else
        MultiJson.decode body
      end
    end

    def parse(body)
      case body
      when ""
        nil
      when "true"
        true
      when "false"
        false
      else
        self.class.parser.call body
      end
    end
  end
end
