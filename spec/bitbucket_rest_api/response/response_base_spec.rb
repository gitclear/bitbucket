require "spec_helper"

describe BitBucket::Response do
  let(:jsonize) { BitBucket::Response::Jsonize.new }
  let(:response_headers) { { "Content-Type" => "application/json" } }

  describe ".on_complete" do
    shared_examples "parses body via on_complete" do |description|
      it description do
        env = { body: input, response_headers: response_headers }
        jsonize.on_complete(env)
        expect(env[:body]).to eq(expected_body)
      end
    end

    context "when body is a JSON string" do
      let(:input) { '{"key":"value"}' }
      let(:expected_body) { MultiJson.load(input) }
      include_examples "parses body via on_complete", "parses JSON into a hash"
    end

    context "when body is already parsed" do
      let(:input) { { "key" => "value" } }
      let(:expected_body) { input }
      include_examples "parses body via on_complete", "leaves the body unchanged"
    end

    context "when body is an empty string" do
      let(:input) { "" }
      let(:expected_body) { nil }
      include_examples "parses body via on_complete", "returns nil"
    end

    context 'when body is "true"' do
      let(:input) { "true" }
      let(:expected_body) { true }
      include_examples "parses body via on_complete", "returns boolean true"
    end

    context 'when body is "false"' do
      let(:input) { "false" }
      let(:expected_body) { false }
      include_examples "parses body via on_complete", "returns boolean false"
    end
  end

  describe ".parse_response?" do
    it "returns true when body responds to to_str" do
      env = { body: "string body" }
      expect(jsonize.parse_response?(env)).to eq(true)
    end

    it "returns false when body does not respond to to_str" do
      env = { body: { "key" => "value" } }
      expect(jsonize.parse_response?(env)).to eq(false)
    end
  end
end
