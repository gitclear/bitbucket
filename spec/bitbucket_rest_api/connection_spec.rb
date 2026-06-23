require "spec_helper"

describe BitBucket::Connection do
  let(:api) { BitBucket::API.new }

  describe "#default_middleware" do
    it "builds the expected middleware stack" do
      middleware = api.default_middleware
      expect(middleware).to be_a(Proc)

      # Request middleware
      handlers = Faraday::RackBuilder.new(&middleware).handlers.map(&:klass)
      expect(handlers).to include(Faraday::Multipart::Middleware)
      expect(handlers).to include(Faraday::Request::UrlEncoded)

      # Response middleware
      expect(handlers).to include(BitBucket::Response::Helpers)
      expect(handlers).to include(BitBucket::Response::Mashify)
      expect(handlers).to include(BitBucket::Response::Jsonize)
      expect(handlers).to include(BitBucket::Response::RaiseError)
    end

    it "excludes Mashify and Jsonize when raw option is set" do
      handlers = Faraday::RackBuilder.new(&api.default_middleware(raw: true)).handlers.map(&:klass)

      expect(handlers).not_to include(BitBucket::Response::Mashify)
      expect(handlers).not_to include(BitBucket::Response::Jsonize)
      expect(handlers).to include(BitBucket::Response::RaiseError)
    end
  end

  describe "#default_options" do
    it "includes the user agent header and default endpoint" do
      options = api.default_options
      expect(options[:headers]["User-Agent"]).to eq(BitBucket::Configuration::DEFAULT_USER_AGENT)
      expect(options[:url]).to eq(BitBucket::Configuration::DEFAULT_ENDPOINT)
    end

    it "allows overriding the endpoint" do
      custom_endpoint = "https://custom.api.example.com"
      options = api.default_options(endpoint: custom_endpoint)
      expect(options[:url]).to eq(custom_endpoint)
    end
  end

  describe "#connection" do
    it "returns a Faraday::Connection" do
      expect(api.connection).to be_a(Faraday::Connection)
    end

    it "uses the default endpoint" do
      conn = api.connection
      expect(conn.url_prefix.to_s).to eq("#{ BitBucket::Configuration::DEFAULT_ENDPOINT }/")
    end
  end
end
