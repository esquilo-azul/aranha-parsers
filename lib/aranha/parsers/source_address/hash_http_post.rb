# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpPost < ::Aranha::Parsers::SourceAddress::HashHttpBase
        HTTP_METHOD = :post
      end
    end
  end
end
