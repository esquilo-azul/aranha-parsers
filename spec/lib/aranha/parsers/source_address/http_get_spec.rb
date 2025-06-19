# frozen_string_literal: true

RSpec.describe Aranha::Parsers::SourceAddress::HttpGet do
  SOURCE_URI = 'http://example.net/abc' # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

  describe '#location_uri' do
    [
      { location: 'http://example.net/def', expected: 'http://example.net/def' },
      { location: '/def', expected: 'http://example.net/def' }
    ].each do |stub|
      context "when source_uri is \"#{SOURCE_URI}\" and location is \"#{stub.fetch(:location)}\"" do
        it "return #{stub.fetch(:expected)}" do
          expect(described_class.location_uri(SOURCE_URI, stub.fetch(:location)))
            .to eq(stub.fetch(:expected))
        end
      end
    end
  end
end
