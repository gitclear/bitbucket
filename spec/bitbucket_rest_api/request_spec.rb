require "spec_helper"
require "bitbucket_rest_api/request"

describe BitBucket::Request do
  # `connection` and `new_access_token` are defined here so rspec-mocks'
  # `verify_partial_doubles` can confirm they exist before stubbing them.
  # They come from `BitBucket::Connection` and `BitBucket::Authorization`
  # respectively, which are not included in this minimal test class.
  let(:fake_api) do
    Class.new do
      include BitBucket::Request

      def connection(options = {}); end
      def new_access_token; end
    end
  end
  let(:faraday_connection) { Faraday.new(url: "https://api.bitbucket.org") }

  describe "request" do
    it "raises an ArgumentError if an unsupported HTTP verb is used" do
      expect { fake_api.new.request(:i_am_a_teapot, {}, "/") }.to raise_error(ArgumentError)
    end

    context "with a connection" do
      before do
        allow_any_instance_of(fake_api).to receive(:connection).and_return(faraday_connection)
        allow_any_instance_of(fake_api).to receive(:new_access_token).and_return("12345")
      end

      it "supports get" do
        stub_request(:get, "https://api.bitbucket.org/1.0/endpoint").
          with(headers: {
            "Authorization" => "Bearer 12345"
          })

        fake_api.new.request(:get, "/1.0/endpoint", {}, {})
      end

      it "supports put" do
        stub_request(:put, "https://api.bitbucket.org/1.0/endpoint").
          with(body: "{\"data\":{\"key\":\"value\"}}",
            headers: {
              "Authorization" => "Bearer 12345"
            })

        fake_api.new.request(:put, "/1.0/endpoint", { "data" => { "key" => "value" } }, {})
      end

      it "supports patch" do
        stub_request(:patch, "https://api.bitbucket.org/1.0/endpoint").
          with(body: "{\"data\":{\"key\":\"value\"}}",
            headers: {
              "Authorization" => "Bearer 12345"
            })

        fake_api.new.request(:patch, "/1.0/endpoint", { "data" => { "key" => "value" } }, {})
      end

      it "supports delete" do
        stub_request(:delete, "https://api.bitbucket.org/1.0/endpoint").
          with(headers: {
            "Authorization" => "Bearer 12345"
          })
        fake_api.new.request(:delete, "/1.0/endpoint", {}, {})
      end

      it "supports post" do
        stub_request(:post, "https://api.bitbucket.org/1.0/endpoint").
          with(body: "{\"data\":{\"key\":\"value\"}}",
            headers: {
              "Authorization" => "Bearer 12345"
            })

        fake_api.new.request(:post, "/1.0/endpoint", { "data" => { "key" => "value" } }, {})
      end
    end
  end
end
