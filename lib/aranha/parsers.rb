# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__ do
  ignore 'patches/ofx_parser'
end

module Aranha
  module Parsers
  end
end

require 'aranha'
require 'eac_envs/http'

require 'aranha/parsers/patches/ofx_parser'
