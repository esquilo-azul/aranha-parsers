# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    module Rspec
      class SourceTargetFixturesController
        enable_simple_cache
        common_constructor :example, :spec_file

        def default_fixtures_dir
          ::File.join(
            ::File.dirname(spec_file),
            ::File.basename(spec_file, '.*') + '_files'
          )
        end

        def fixtures_dir
          if example.respond_to?(:fixtures_dir)
            example.fixtures_dir
          else
            default_fixtures_dir
          end
        end

        def write_target_fixtures?
          ENV['WRITE_TARGET_FIXTURES'].to_bool
        end

        private

        def source_target_fixtures_uncached
          ::Aranha::Parsers::SourceTargetFixtures.new(fixtures_dir)
        end
      end
    end
  end
end
