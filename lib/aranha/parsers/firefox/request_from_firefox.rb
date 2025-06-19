# frozen_string_literal: true

module Aranha
  module Parsers
    module Firefox
      class RequestFromFirefox
        BASE_URL_SUBPATH = 'base_url'
        BODY_SUBPATH = 'body'
        REQUEST_SUBPATH = 'request'

        class << self
          def from_directory(path)
            path = path.to_pathname
            body_path = path.join(BODY_SUBPATH)
            new(
              path.join(BASE_URL_SUBPATH).read.strip,
              ::Aranha::Parsers::Firefox::RequestHeaderFromFirefox
              .from_file(path.join(REQUEST_SUBPATH)),
              body_path.file? ? body_path.read : nil
            )
          end
        end

        enable_simple_cache
        common_constructor :the_base_uri, :header, :body, default: [nil] do
          self.the_base_uri = the_base_uri.to_uri
        end

        def to_uri_source
          {
            method: header.verb,
            url: url,
            headers: header.headers,
            body: body
          }
        end

        def url
          (the_base_uri + header.uri).to_s
        end
      end
    end
  end
end
