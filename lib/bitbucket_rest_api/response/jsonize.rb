# encoding: utf-8

require "faraday"
require "multi_json"

module BitBucket
  class Response::Jsonize < Response

    define_parser do |body|
      MultiJSON.parse body
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
