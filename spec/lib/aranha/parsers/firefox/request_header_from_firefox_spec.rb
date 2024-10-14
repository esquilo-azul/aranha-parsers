# frozen_string_literal: true

require 'aranha/parsers/firefox/request_header_from_firefox'

RSpec.describe Aranha::Parsers::Firefox::RequestHeaderFromFirefox do
  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    described_class.from_file(source_file).to_h
  end
end
