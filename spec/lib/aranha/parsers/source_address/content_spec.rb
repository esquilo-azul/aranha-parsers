# frozen_string_literal: true

RSpec.describe Aranha::Parsers::SourceAddress, '#content' do
  let(:http_server) { EacEnvs::Http::Rspec::EchoServer.http }

  around { |example| http_server.on_active(&example) }

  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    source = EacRubyUtils::Yaml.load_file(source_file)
    url = source_url_get(source)
    %w[scheme host port].each { |attr| url.send("#{attr}=", http_server.root_url.send(attr)) }
    if source.is_a?(Hash)
      source[:url] = url.to_s
    else
      source = url.to_s
    end
    JSON.parse(described_class.detect_sub(source).content)
  end

  # @return [Addressable::URI]
  def source_url_get(source)
    (source.is_a?(Hash) ? source.fetch(:url) : source).to_uri
  end

  def target_data(target_file)
    r = EacRubyUtils::Yaml.load_file(target_file)
    r.fetch('headers')['host'] = http_server.root_url.authority if r.fetch('headers').key?('host')
    r
  end
end
