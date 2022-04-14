# frozen_string_literal: true

require 'aranha/parsers/source_address/hash_http_base'

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpGet < ::Aranha::Parsers::SourceAddress::HashHttpBase
        HTTP_METHOD = :get
      end
    end
  end
end
