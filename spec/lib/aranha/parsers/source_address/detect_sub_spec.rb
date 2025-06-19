# frozen_string_literal: true

RSpec.describe Aranha::Parsers::SourceAddress, '#detect_sub' do
  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    sub = described_class.detect_sub(EacRubyUtils::Yaml.load_file(source_file))
    {
      klass: sub.class, url: sub.url, serialization: sub.serialize,
      deserialization: described_class.deserialize(sub.serialize).sub
    }
  end
end
