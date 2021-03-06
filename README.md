# Restivus

REST APIs for the rest of us.

## Description

Restivus makes it easy to expose a CSV file as a fully-documented REST API.

This is an experiment to see how DRY an API can be. Down the road, I'd like this library to also generate client SDKs in different languages.

This is a very early release, the code is not stable, tested, or reliable...yet. Use at your own risk, yada yada yada (see LICENSE.txt for the real terms).

## Installation

`gem "restivus", "~> 0.0.3"` or `gem install restivus`

## Usage

The `Restivus` class inherits from `Sinatra::Base`. A Restivus app can be just a few lines of code:

```ruby
require 'restivus'

class Bank < Restivus
  pk "Bank_Name"     # defaults to "id"
  csv "banklist.csv" # from http://www.fdic.gov/bank/individual/failed/banklist.csv
end

Bank.run! # visit localhost:4567/docs
```

Right now, Heroku chokes when rendering the docs page, so I'm going to try to use the Stasis gem to generate static docs pages.

## Contributing to Restivus

### If you can't code
* Find typos in the docs

### If you can code
* Add cool stuff, give me feedback, open issues, request features

### Submitting changes:
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Alan deLevie. See LICENSE.txt for
further details.

