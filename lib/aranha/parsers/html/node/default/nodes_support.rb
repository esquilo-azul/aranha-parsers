# frozen_string_literal: true

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          module NodesSupport
            # @param node [Nokogiri::XML::Node]
            # @param xpath [String]
            # @return [Nokogiri::XML::NodeSet]
            def node_set_value(node, xpath)
              node.xpath(xpath)
            end

            # @param node [Nokogiri::XML::Node]
            # @param xpath [String]
            # @return [Nokogiri::XML::Node]
            def node_value(node, xpath)
              node.at_xpath(xpath)
            end
          end
        end
      end
    end
  end
end
