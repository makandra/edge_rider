Edge Rider [![Build Status](https://secure.travis-ci.org/makandra/edge_rider.png?branch=master)](https://travis-ci.org/makandra/edge_rider)
====================================

Power tools for Active Record relations (scopes)
-------------------------------------------------

TODO: Write README


Installation
------------

In your `Gemfile` say:

    gem 'edge_rider'

Now run `bundle install` and restart your server.



Development
-----------

- Test applications for various Rails versions lives in `spec`.
- You need to create a MySQL database and put credentials into `spec/shared/app_root/config/database.yml`.
- You can bundle all test applications by saying `bundle exec rake all:bundle`
- You can run specs from the project root by saying `bundle exec rake all:spec`.

If you would like to contribute:

- Fork the repository.
- Push your changes **with passing specs**.
- Send me a pull request.

I'm very eager to keep this gem leightweight and on topic. If you're unsure whether a change would make it into the gem, [talk to me beforehand](mailto:henning.koch@makandra.de).


Credits
-------

Henning Koch from [makandra](http://makandra.com/)
