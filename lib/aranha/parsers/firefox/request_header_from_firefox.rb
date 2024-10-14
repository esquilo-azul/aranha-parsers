# frozen_string_literal: true

module Aranha
  module Parsers
    module Firefox
      class RequestHeaderFromFirefox
        class << self
          def from_file(path)
            new(path.to_pathname.read)
          end
        end

        FIRST_LINE_PARSER = /\A(\S+)\s(\S+)\s(\S+)\z/.to_parser do |m|
          { verb: m[1], uri: m[2], version: m[3] }
        end

        HEADER_LINE_PARSER = /\A([^:]+):\s+(.+)\z/.to_parser do |m|
          m[1..2]
        end

        enable_simple_cache

        common_constructor :string

        def to_h
          %w[verb uri headers].index_with { |m| send(m) }
        end

        def headers
          all_except_first_line.map { |line| HEADER_LINE_PARSER.parse!(line) }.to_h # rubocop:disable Style/MapToHash
        end

        def verb
          parsed_first_line.fetch(:verb)
        end

        def uri
          parsed_first_line.fetch(:uri)
        end

        private

        def all_lines_uncached
          string.each_line.map(&:strip)
        end

        def parsed_first_line_uncached
          FIRST_LINE_PARSER.parse!(all_lines.first)
        end

        def all_except_first_line
          all_lines[1..-1] # rubocop:disable Style/SlicingWithRange
        end
      end
    end
  end
end
