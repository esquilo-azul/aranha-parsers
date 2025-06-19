# frozen_string_literal: true

require 'json'

module Aranha
  module Parsers
    module Json
      class Base < ::Aranha::Parsers::Base
        def data
          default_data
        end

        def default_data
          ::JSON.parse(content)
        end
      end
    end
  end
end
