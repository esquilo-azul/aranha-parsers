# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    module Rspec
      class Setup
        common_constructor :setup_obj

        def perform
          require 'aranha/parsers/rspec/source_target_fixtures_example'
        end
      end
    end
  end
end
