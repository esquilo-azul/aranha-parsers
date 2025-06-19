# frozen_string_literal: true

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          module StringSupport
            def quoted_value(node, xpath)
              s = string_value(node, xpath)
              return '' unless s

              m = /"([^\"]+)"/.match(s)
              return m[1] if m

              ''
            end

            def regxep(node, xpath, pattern)
              s = string_value(node, xpath)
              m = pattern.match(s)
              return m if m

              raise "Pattern \"#{pattern}\" not found in string \"#{s}\""
            end

            # @param node [Nokogiri::XML::Node]
            # @param xpath [String]
            # @return [String]
            def string_value(node, xpath)
              found = node_value(node, xpath)
              found ? sanitize_string(found.text) : ''
            end

            def string_recursive_value(node, xpath, required = true) # rubocop:disable Style/OptionalBooleanParameter
              root = node_value(node, xpath)
              if root.blank?
                return nil unless required

                raise "No node found (Xpath: #{xpath})"
              end
              result = string_recursive(root)
              return result if result.present?
              return nil unless required

              raise "String blank (Xpath: #{xpath})"
            end

            def string_recursive_optional_value(node, xpath)
              string_recursive_value(node, xpath, false)
            end

            private

            def sanitize_string(obj)
              obj.to_s.tr("\u00A0", ' ').strip
            end

            def string_recursive(node)
              return sanitize_string(node.text) if node.is_a?(::Nokogiri::XML::Text)

              s = ''
              node.children.each do |child|
                child_s = string_recursive(child)
                s += " #{child_s}" if child_s.present?
              end
              sanitize_string(s)
            end
          end
        end
      end
    end
  end
end
