# frozen_string_literal: true

require_dependency 'aranha/parsers/firefox/uri_from_har'

RSpec.describe Aranha::Parsers::Firefox::UriFromHar do
  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    described_class.from_file(source_file).result
  end
end
