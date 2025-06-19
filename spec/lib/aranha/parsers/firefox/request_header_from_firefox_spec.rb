# frozen_string_literal: true

RSpec.describe Aranha::Parsers::Firefox::RequestHeaderFromFirefox do
  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    described_class.from_file(source_file).to_h
  end
end
