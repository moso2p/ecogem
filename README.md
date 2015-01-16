# Ecogem

Supplements Bundler for installing private gems. https://rubygems.org/gems/ecogem

## Preface

When my gem A depends on my private gem B whose source is served from GitHub, I can specify B's location with _:git_ in A's Gemfile rather than A's gemspec in development.

A's Gemfile:

```ruby
source 'https://rubygems.org'
gem 'gem-b', git: 'git@github.com:me/gem-b.git'
gemspec
```

It's cool. So, I want to use A in my application.

My application's Gemfile:

```ruby
source 'https://rubygems.org'
gem 'gem-a', git: 'git@github.com:me/gem-a.git'
```

Then `bundle install` prints:

    Could not find gem 'gem-b (>= 0) ruby', which is required by gem 'gem-a (>= 0) ruby', in any of the sources.

Oh, my! Of course, Bundler does not resolve dependencies specified outside gemspec recursively.

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
    * Windows and several other platforms are not supported; please contribute!

* Ruby >= 2.1 and ~> 2.2
    * Tested on 2.1.5 (MRI)

* Bundler >= 1.7.9
    * Tested with 1.7.9

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

1. fetch the gem-a repo and parse gem-a's Ecogemfile

    gem-a's Ecogemfile: 

    ```ruby
    source 'https://rubygems.org'
    gem 'gem-b', git: 'git@github.com:me/gem-b.git'
    gemspec
    ```

1. fetch the gem-b repo and parse gem-b's Ecogemfile

    gem-b's Ecogemfile:

    ```ruby
    source 'https://rubygems.org'
    gemspec
    ```

1. create a new Gemfile file

    Gemfile:

    ```ruby
    require "ecogem"

    source "https://rubygems.org/"

    gem "gem-b", path: Ecogem.git_path("git@github.com:me/gem-b.git master")
    gem "gem-a", path: Ecogem.git_path("git@github.com:me/gem-a.git master")
    gem "rake"
    ```

1. and finally execute `bundle install` with the new Gemfile

## Configuration File

Ecogem reads your configuration file and configures its runtime environment.

The location of file is `~/.ecogem/config`. ~ is the current user's home directory.

## Multiple SSH Keys for Fetching Repositories

Ecogem supports multiple SSH keys for fetching repositories, described at [this gist](https://gist.github.com/jexchan/2351996
).

Write your uri aliases in your config like:

```yaml
git_sources:
- uri: git@github.com:username/my.git
  uri_alias: git@github.com-username:username/my.git
```

Then Ecogem converts the uri to the uri_alias.

## Contributing

1. Fork it ( https://github.com/moso2p/ecogem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
