# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceTargetFixtures
      class SourceTargetFile
        common_constructor :owner, :basename

        def source
          owner.source_file(basename)
        end

        def target
          owner.target_file(basename)
        end
      end
    end
  end
end
