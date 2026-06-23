require "spec_helper"
require "bitbucket_rest_api/core_ext/array"

describe BitBucket::Request::BasicAuth do
  let(:app) { ->(env) { env } }
  let(:login) { "user" }
  let(:password) { "pass" }
  let(:credentials) { "#{ login }:#{ password }" }
  let(:expected_header) { "Basic #{ Base64.strict_encode64(credentials) }" }

  shared_examples "adds basic auth header" do
    it "sets the Authorization header with base64-encoded credentials and no trailing quote" do
      env = { request_headers: {} }
      @middleware.call(env)
      expect(env[:request_headers]["Authorization"]).to eq(expected_header)
      # Guards against a prior bug where the header had a trailing double-quote
      expect(env[:request_headers]["Authorization"]).not_to end_with('"')
    end
  end

  describe "with login and password" do
    before { @middleware = described_class.new(app, login: login, password: password) }
    include_examples "adds basic auth header"
  end

  describe "with basic_auth string" do
    before { @middleware = described_class.new(app, basic_auth: credentials) }
    include_examples "adds basic auth header"
  end

  describe "with no credentials" do
    let(:credentials) { "" }

    before { @middleware = described_class.new(app) }
    include_examples "adds basic auth header"
  end
end
