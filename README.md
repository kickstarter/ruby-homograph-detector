# ruby-homograph-detector

Ruby gem for determining whether a given URL is considered an [IDN homograph attack]. The underlying algorithm used in this gem is loosely based on [Google Chrome’s IDN display algorithm]. To learn more about why and how you defend against homograph attacks, see [this blog post].

[IDN homograph attack]: https://en.wikipedia.org/wiki/IDN_homograph_attack
[Google Chrome’s IDN display algorithm]: https://www.chromium.org/developers/design-documents/idn-in-google-chrome
[this blog post]: https://dev.to/loganmeetsworld/homographs-attack--5a1p

## Installation

Install the `homograph-detector` gem, or add it to your Gemfile with bundler:

```ruby
# In your Gemfile
gem 'homograph-detector'
```

## Usage

The `homograph-detector` gem provides a single function `homograph_attack?` which takes a URL string and determines if the URL is considered a homograph attack:

```ruby
HomographDetector.homograph_attack?('<your URL here>')
```

## Examples

URL with Latin characters:


```ruby
HomographDetector.homograph_attack?('https://paypal.com') # false
```

URL with [confusable] Cyrillic characters:

```ruby
HomographDetector.homograph_attack?('https://раураӏ.com') # true
```

URL with non-confusable Cyrillic characters:

```ruby
HomographDetector.homograph_attack?('http://яндекс.рф') # false
```

URL with multiple scripts:

```ruby
# Greek and Latin
HomographDetector.homograph_attack?('wikiρedia.org') # true

# Japanese and Latin
HomographDetector.homograph_attack?('hello你好.com') # false
```

[confusable]: http://www.unicode.org/reports/tr39/#Confusable_Detection

## License

Licensed under Apache License, Version 2.0 ([LICENSE.txt](LICENSE.txt) or http://www.apache.org/licenses/LICENSE-2.0).

For a summary of the licenses used by ruby-homograph-detector’s dependencies, see [NOTICE.md](NOTICE.md).
