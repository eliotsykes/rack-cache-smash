require_relative 'test_helper'

class Rack::UncacheTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    #ensure_correct_working_directory
    @body = nil
    @headers = {'Content-Type' => 'text/html'}
  end

  #def teardown
  #  revert_to_original_working_directory
  #end

  def app
    status = 200
    rack_app = lambda { |env| [status, @headers, @body] }
    Rack::Uncache.new(rack_app)
  end

  def test_js_path_gets_cache_busted
    assert_body_transform(
        [
            '<html><head>',
            '<script src="/assets/application.js"></head><body>',
            'Hello</body></html>',
        ],
        "<html><head><script src=\"/assets/application.js?cachebuster=[TIMESTAMP]\"></head><body>Hello</body></html>",
    )
  end

  def test_css_path_gets_cache_busted
    assert_body_transform(
        [
            '<html><head>',
            "<link href='/assets/typography.css' rel='stylesheet' type='text/css'></head><body>",
            'Hello</body></html>',
        ],
        "<html><head><link href='/assets/typography.css?cachebuster=[TIMESTAMP]' rel='stylesheet' type='text/css'></head><body>Hello</body></html>"
    )
  end

  def test_js_path_with_query_string_gets_cache_busted
    assert_body_transform(
        [
            '<html><head>',
            '<script src="/assets/angular.js?body=1"></head><body>',
            'Hello</body></html>',
        ],
        "<html><head><script src=\"/assets/angular.js?cachebuster=[TIMESTAMP]&body=1\"></head><body>Hello</body></html>",
    )
  end

  def test_css_path_with_query_string_gets_cache_busted
    assert_body_transform(
        [
            '<html><head>',
            "<link href='/assets/layout.css?foo=bar&hello=world' rel='stylesheet' type='text/css'></head><body>",
            'Hello</body></html>',
        ],
        "<html><head><link href='/assets/layout.css?cachebuster=[TIMESTAMP]&foo=bar&hello=world' rel='stylesheet' type='text/css'></head><body>Hello</body></html>"
    )
  end

  def test_multiple_asset_paths_get_cache_busted
    assert_body_transform(
        [
            '<html><head>',
            "<script src='https://somewhere.tld/some/path/to/analytics.js'>",
            "<link href='/assets/layout.css?foo=bar&hello=world' rel='stylesheet' type='text/css'>",
            "<link href='/assets/footer.css' rel='stylesheet' type='text/css'></head><body>",
            'Hello<script type="text/javascript" src="jquery.js"><script type="text/javascript" src="plugin.js?woo=hoo"></body></html>'
        ],
        "<html><head><script src='https://somewhere.tld/some/path/to/analytics.js?cachebuster=[TIMESTAMP]'>" +
        "<link href='/assets/layout.css?cachebuster=[TIMESTAMP]&foo=bar&hello=world' rel='stylesheet' type='text/css'>" +
        "<link href='/assets/footer.css?cachebuster=[TIMESTAMP]' rel='stylesheet' type='text/css'></head><body>" +
        "Hello<script type=\"text/javascript\" src=\"jquery.js?cachebuster=[TIMESTAMP]\">" +
        "<script type=\"text/javascript\" src=\"plugin.js?cachebuster=[TIMESTAMP]&woo=hoo\"></body></html>"
    )
  end

  def test_does_not_modify_non_html_responses
    @headers['Content-Type'] = 'text/plain'
    @body = [
        '<html><head>',
        "<link href='/assets/typography.css' rel='stylesheet' type='text/css'></head><body>",
        'Hello</body></html>',
    ]
    unmodified_body_str = @body.join('')

    get '/'

    assert_equal unmodified_body_str, last_response.body
    assert_equal 'text/plain', last_response.headers['content-type']
  end

  def test_handles_html_content_type_with_charset_specified
    @headers['Content-Type'] = 'text/html; charset=utf-8'
    assert_body_transform(
        [
            '<html><head>',
            '<script src="/assets/application.js"></head><body>',
            'Hello</body></html>',
        ],
        "<html><head><script src=\"/assets/application.js?cachebuster=[TIMESTAMP]\"></head><body>Hello</body></html>",
    )
  end

  def test_content_length_gets_updated
    flunk
  end

  private

  def assert_body_transform(original, result)
    @body = original

    Timecop.freeze do
      get '/'

      timestamp = Time.now.utc.to_i
      assert_equal(
          result.gsub('[TIMESTAMP]', timestamp.to_s),
          last_response.body
      )
      assert_match /(text\/html)|(text\/html; charset=utf-8)/, last_response.headers['content-type']
    end
  end

  def assert_underlying_app_responded
    assert_response_ok
    assert_equal 'Up above the streets and houses', last_response.body
  end

  def assert_response_ok
    assert_equal 200, last_response.status
  end

  def assert_not_found(msg=nil)
    assert_equal 404, last_response.status, msg
    assert_equal 'Not Found', last_response.body, msg
  end

  #def ensure_correct_working_directory
  #  is_project_root_working_directory = File.exists?('rack-uncache.gemspec')
  #  if is_project_root_working_directory
  #    @original_dir = Dir.pwd
  #    Dir.chdir 'test'
  #  end
  #end
  #
  #def revert_to_original_working_directory
  #  Dir.chdir @original_dir if @original_dir
  #end

end