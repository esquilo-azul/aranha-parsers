# frozen_string_literal: true

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          module MiscellaneousSupport
            # @param node [Nokogiri::XML::Node]
            # @param xpath [String]
            # @return [Boolean]
            def boolean_value(node, xpath)
              node_value(node, xpath).to_bool
            end
          end
        end
      end
    end
  end
end
