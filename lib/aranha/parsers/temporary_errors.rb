# frozen_string_literal: true

module Aranha
  module Parsers
    module TemporaryErrors
      ALL_ERRORS = [::Aranha::Parsers::InvalidStateException,
                    ::Aranha::Parsers::SourceAddress::FetchContentError].freeze

      class << self
        def errors
          ALL_ERRORS
        end
      end
    end
  end
end
