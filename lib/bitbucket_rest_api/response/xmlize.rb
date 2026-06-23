# encoding: utf-8

require "faraday"
require "nokogiri"

module BitBucket
  class Response::Xmlize < Response

    define_parser do |body|
      ::Nokogiri::XML body
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
