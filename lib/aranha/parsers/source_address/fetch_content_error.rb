# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceAddress
      class FetchContentError < ::RuntimeError
        attr_reader :request

        def initialize(msg, request)
          super(msg)
          @request = request
        end
      end
    end
  end
end
