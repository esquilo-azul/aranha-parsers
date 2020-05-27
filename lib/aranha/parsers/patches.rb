# frozen_string_literal: true

require 'eac_ruby_utils/require_sub'

module Aranha
  module Parsers
    module Patches
      ::EacRubyUtils.require_sub __FILE__
    end
  end
end
