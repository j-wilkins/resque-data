# Resque::Data

Resque Data is a small Sinatra based Rack app that will fetch basic information
about a Resque instance.

It has no security, and very little polish. Use at your own risk.

That said, I'm using it to serve up Resque stats for internal apps, and it
seems to work ok.

## Installation

Add this line to your application's Gemfile:

    gem 'resque-data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-data

## Usage

The easiest way to use `Resque::Data` is going to be mounting it as an engine.

```
   mount Resque::Data::Server, at: 'resque_data'
```

I'm hoping to get around to writing a `resque_data` executable, but until
then there's a `config.ru` sitting the the `lib` folder that you can use.

### Configuration

You have a few configuration options off of `Resque::Data::Config`:

 * `default_redis`  - set the redis to be used when none is specified.
 * `multi_namespace` - specify whether to accept a namespace parameter. Default: true
 * `multi_redis`    - specifiy whether to accept a redis parameter. Default: true

Currently, you're going to get weird results if you allow `multi_redis` without
allowing `multi_namespace`, but I'm not really sure why you'd want to do that.

You set these options like:

```
   Resque::Data::Config.<option> = <whatever>
```

Also, the configuration is currently persisted when `Resque::Data::Server` is
loaded, this is something to do with it being in a Sinatra `configuration`
block. However, if all you do is configure it in an initializer then mount it
you should never notice this.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
