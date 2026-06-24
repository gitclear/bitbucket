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
      let(:expected_body) { MultiJSON.parse(input) }
      include_examples "parses body via on_complete", "parses JSON into a hash"
    end

    context "when body is a hash (Jsonize only handles strings)" do
      it "raises an error because MultiJSON.parse expects a string" do
        env = { body: { "key" => "value" }, response_headers: response_headers }
        expect { jsonize.on_complete(env) }.to raise_error(NoMethodError)
      end
    end

    context "when body is an empty string" do
      let(:input) { "" }
      let(:expected_body) { nil }
      include_examples "parses body via on_complete", "delegates to parser which returns nil"
    end

    context "when body is nil" do
      let(:input) { nil }
      let(:expected_body) { nil }
      include_examples "parses body via on_complete", "skips parsing and leaves body unchanged"
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

    context "when Mashify processes a hash body" do
      let(:mashify) { BitBucket::Response::Mashify.new }
      let(:name_one) { "one" }
      let(:name_two) { "two" }

      it "converts hash to Hashie::Mash" do
        env = { body: { "name" => name_one }, response_headers: response_headers }
        mashify.on_complete(env)
        expect(env[:body]).to be_a(Hashie::Mash)
        expect(env[:body].name).to eq(name_one)
      end

      it "converts array of hashes to array of Hashie::Mash" do
        env = { body: [{ "name" => name_one }, { "name" => name_two }], response_headers: response_headers }
        mashify.on_complete(env)
        expect(env[:body][0]).to be_a(Hashie::Mash)
        expect(env[:body][0].name).to eq(name_one)
        expect(env[:body][1].name).to eq(name_two)
      end
    end
  end
end
