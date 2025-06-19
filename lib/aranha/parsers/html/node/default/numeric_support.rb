# frozen_string_literal: true

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          module NumericSupport
            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Float]
            def decimal_comma_value(node, xpath)
              parse_decimal_comma(node, xpath, true)
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Float, nil]
            def decimal_comma_optional_value(node, xpath)
              parse_decimal_comma(node, xpath, false)
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Float]
            def decimal_dot_value(node, xpath)
              parse_decimal_dot(node, xpath, true)
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Float, nil]
            def decimal_dot_optional_value(node, xpath)
              parse_decimal_dot(node, xpath, false)
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Integer]
            def integer_comma_value(node, xpath)
              decimal_comma_value(node, xpath).to_i
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Integer]
            def integer_comma_optional_value(node, xpath)
              decimal_comma_optional_value(node, xpath).to_i
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Integer]
            def integer_dot_value(node, xpath)
              decimal_dot_value(node, xpath).to_i
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Integer]
            def integer_dot_optional_value(node, xpath)
              decimal_dot_optional_value(node, xpath).to_i
            end

            def integer_value(node, xpath)
              r = string_value(node, xpath)
              return nil if r.blank?

              m = /\d+/.match(r)
              raise "Integer not found in \"#{r}\"" unless m

              m[0].to_i
            end

            def integer_optional_value(node, xpath)
              r = string_value(node, xpath)
              m = /\d+/.match(r)
              m ? m[0].to_i : nil
            end

            def float_value(node, xpath)
              parse_float(node, xpath, true)
            end

            def float_optional_value(node, xpath)
              parse_float(node, xpath, false)
            end

            # @deprecated Use {#decimal_dot_value} instead.
            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Float]
            def us_decimal_value(node, xpath)
              decimal_dot_value(node, xpath)
            end

            # @deprecated Use {#decimal_dot_optional_value} instead.
            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @return [Float, nil]
            def us_decimal_optional_value(node, xpath)
              decimal_dot_optional_value(node, xpath)
            end

            private

            def parse_float(node, xpath, required)
              s = string_value(node, xpath)
              m = /\d+(?:[\.\,](\d+))?/.match(s)
              if m
                m[0].delete('.').tr(',', '.').to_f
              elsif required
                raise "Float value not found in \"#{s}\""
              end
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @param required [Boolean]
            # @param separator [String]
            # @param delimiter [String]
            # @return [Float, nil]
            def parse_decimal(node, xpath, required, separator, delimiter)
              s = string_value(node, xpath)
              m = /\d+(?:[#{::Regexp.quote(separator + delimiter)}](\d+))?/.match(s)
              if m
                m[0].delete(delimiter).to_f
              elsif required
                raise "decimal [Separator=\"#{separator}, Delimiter=\"#{delimiter}\"] value not " \
                      "found in \"#{s}\""
              end
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @param required [Boolean]
            # @return [Float, nil]
            def parse_decimal_dot(node, xpath, required)
              parse_decimal(node, xpath, required, '.', ',')
            end

            # @param node [Nokogiri::XML::Element]
            # @param xpath [String]
            # @param required [Boolean]
            # @return [Float, nil]
            def parse_decimal_comma(node, xpath, required)
              parse_decimal(node, xpath, required, ',', '.')
            end
          end
        end
      end
    end
  end
end
