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

            # @param node [Nokogiri::XML::Node]
            # @param xpath [String]
            # @return [String]
            def node_xml_value(node, xpath)
              found = node_value(node, xpath)
              found ? found.to_xml : ''
            end

            # @param node [Nokogiri::XML::Node]
            # @param xpath [String]
            # @return [String]
            def node_set_xml_value(node, xpath)
              found = node_set_value(node, xpath)
              found ? found.to_xml : ''
            end
          end
        end
      end
    end
  end
end
