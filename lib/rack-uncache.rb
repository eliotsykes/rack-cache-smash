require 'rack-uncache/version'

module Rack
  class Uncache

    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)
      headers = response[1]

      if headers['Content-Type'] != 'text/html'
        return response
      end

      status = response.first
      original_body_arr = response.last
      body_str = cache_bust_asset_paths_in_body(original_body_arr)
      return [status, headers, [body_str]]
    end

    private

    REGEXP_FOR_PATHS_TO_CACHE_BUST = /(?<ext>\.(?:js|css))(?:(?:\?)(?<query_string>.*?))?(?<end_quote>['"])/

    def cache_bust_asset_paths_in_body(original_body_arr)
      body_str = original_body_arr.join('')
      timestamp = Time.now.utc.to_i
      body_str.gsub!(REGEXP_FOR_PATHS_TO_CACHE_BUST) do |match|
        query_string_suffix = $~[:query_string] ? "&#{$~[:query_string]}" : ''
        "#{$~[:ext]}?cachebuster=#{timestamp}#{query_string_suffix}#{$~[:end_quote]}"
      end
      return body_str
    end

  end
end
