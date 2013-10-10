require 'rack-cache-smash/version'

module Rack
  class CacheSmash

    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)
      headers = response[1]
      return response unless html_response?(headers)

      status = response.first
      original_body_arr = response.last
      body_str = cache_bust_asset_paths_in_body(original_body_arr)
      return [status, headers, [body_str]]
    end

    private

    PATHS_TO_CACHE_BUST_REGEXP = /(?<ext>\.(?:js|css))(?:(?:\?)(?<query_string>.*?))?(?<end_quote>['"])/
    HTML_CONTENT_TYPE_REGEXP = /\Atext\/html.*\z/

    def html_response?(headers)
      headers['Content-Type'] =~ HTML_CONTENT_TYPE_REGEXP
    end

    def cache_bust_asset_paths_in_body(original_body_arr)
      body_str = original_body_arr.join('')
      timestamp = Time.now.utc.to_i
      body_str.gsub!(PATHS_TO_CACHE_BUST_REGEXP) do |match|
        query_string_suffix = $~[:query_string] ? "&#{$~[:query_string]}" : ''
        "#{$~[:ext]}?cachebuster=#{timestamp}#{query_string_suffix}#{$~[:end_quote]}"
      end
      return body_str
    end

  end
end
