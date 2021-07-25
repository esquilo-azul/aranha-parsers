# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    module Rspec
      module SetupInclude
        class << self
          def setup(_setup_obj)
            require 'aranha/parsers/rspec/source_target_fixtures_example'
          end
        end
      end
    end
  end
end
