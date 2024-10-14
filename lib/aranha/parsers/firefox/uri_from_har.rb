# frozen_string_literal: true

require 'json'

module Aranha
  module Parsers
    module Firefox
      class UriFromHar
        class << self
          def from_file(path)
            new(::JSON.parse(path.to_pathname.read))
          end
        end

        common_constructor :data

        def result
          data.fetch('log').fetch('entries').map { |e| e.fetch('request').fetch('url') }
        end

        def request_data; end
      end
    end
  end
end
