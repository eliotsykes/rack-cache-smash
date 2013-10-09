# rack-uncache

rack-uncache is a Rack middleware to cache bust **every** CSS and JS asset request, intended for development environments
only and not recommended for production.

Cache busting happens by modifying all HTML responses that contain paths to JS and CSS files. These file paths are appended
with a timestamp query string parameter to force browsers to re-download the files for every single page load as they always have a unique URL.

Admittedly, this is a sledgehammer of a middleware to overcome those browser caching issues that sometimes arise during development. I don't advise
using it in production, and I doubt that you want to.

At the time of writing this, I'm using rack-uncache during development to overcome a [problem in iOS 7.0.2 where incomplete asset downloads seem to be cached](http://tech.vg.no/2013/10/02/ios7-bug-shows-white-page-when-getting-304-not-modified-from-server/)
and some weirdness I've seen in IE10 on Windows 8 with assets, 304 Not Modified responses, and SSL.


## Installation

Add the rack-uncache gem to the development group your application's Gemfile:

    group :development do
        ...
        gem 'rack-uncache'
    end

And then execute:

    $ bundle

Add this line to config/application.rb:

    config.middleware.swap(ActionDispatch::Static, Rack::Uncache)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run tests (`rake test`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Releasing a new gem

1. Increment version in lib/rack-uncache/version.rb in line with semantic versioning
2. Update CHANGELOG.md
3. Tests pass? (`rake test`)
4. Build the gem (`rake build`)
5. Release on rubygems.org (`rake release`)

