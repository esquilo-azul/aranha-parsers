# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    module Rspec
      module Setup
        def self.extended(_setup_obj)
          require 'aranha/parsers/rspec/shared_examples/source_target_fixtures'
        end
      end
    end
  end
end
