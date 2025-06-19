# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpGet < ::Aranha::Parsers::SourceAddress::HashHttpBase
        HTTP_METHOD = :get
      end
    end
  end
end
