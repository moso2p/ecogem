# Ecogem

Supplements Bundler for installing private gems.

## Preface

When the gem A depends on my private gem B whose source is served from GitHub, I can write Gemfile with _:git_ option.

A's Gemfile:

```ruby
source 'https://rubygems.org'
gem 'gem-b', git: 'git@github.com:me/gem-b.git'
gemspec
```

It's cool. So, I also want to privately put A's source onto GitHub and use A in my application.

My application's Gemfile:

```ruby
source 'https://rubygems.org'
gem 'gem-a', git: 'git@github.com:me/gem-a.git'
```

Then `bundle install` prints:

    Could not find gem 'gem-b (>= 0) ruby', which is required by gem 'gem-a (>= 0) ruby', in any of the sources.

Oh, my! Bundler does not resolve such deep dependencies.

To solve this, I need to:

* add the dependency again like:

    ```ruby
    gem 'gem-a', git: 'git@github.com:me/gem-a.git'
    gem 'gem-b', git: 'git@github.com:me/gem-b.git'
    ```

    It's terrible. Where is DRY?

* host my private Gem server

    The regular Gem server protocol is not suitable to exchange private resources because it has no sophisticated authentication method such as SSH.

* subscribe to Gemfury

    Better than self hosting, however, there is still the problem about authentication.

* make Rubygems accept Git sources

* make Bundler resolve nested Git dependencies

    These two seem to take forever.

Okay. The last option is Ecogem.

## Dependencies

* fork(2)
    * Windows and several other platforms are not supported.

* Ruby >= 2.1 and ~> 2.2
    * Tested on 2.1.5 (MRI)

* Bundler >= 1.7.9
    * Tested on 1.7.9

## Installation

Install the gem:

    $ gem install ecogem

Also install Bundler if not installed:

    $ gem install bundler

## Usage

Rename all your Gemfiles to Ecogemfiles and execute:

    $ ecogem install

## Example

When

* My application depends on gem-a whose source is served from GitHub
* gem-a depends on gem-b whose source is served from GitHub

Then `ecogem install` will:

1. parse Ecogemfile

    Ecogemfile:

    ```ruby
    source 'https://rubygems.org'
    gem 'gem-a', git: 'git@github.com:me/gem-a.git'
    gem 'rake' # from rubygems.org
    ```

1. fetch gem-a's Ecogemfile

    gem-a's Ecogemfile: 

    ```ruby
    source 'https://rubygems.org'
    gem 'gem-b', git: 'git@github.com:me/gem-b.git'
    gemspec
    ```

1. fetch gem-b's Ecogemfile

    gem-b's Ecogemfile:

    ```ruby
    source 'https://rubygems.org'
    gemspec
    ```

1. create a new Gemfile file

    Gemfile:

    ```ruby
    require "ecogem"

    source "https://rubygems.org"

    gem 'gem-b', Ecogem.git_path("git@github.com:me/gem-b.git master")
    gem 'gem-a', Ecogem.git_path("git@github.com:me/gem-a.git master")
    gem 'rake'
    ```

1. and finally execute `bundle install` with the new Gemfile

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ecogem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
