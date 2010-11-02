# Manage your Heroku Config Vars

See the blog [post](http://blog.leshill.org/blog/2010/11/02/heroku-environment-variables.html).

## Install

Copy `heroku.thor` to `lib/tasks/heroku.thor`, `heroku_env.rb` to `config/heroku_env.rb`, and `heroku.example.yml` to `config/heroku.yml`. Modify the `heroku.yml` to suit your application.

Modify `config/application.rb` (at the top of the file)


    require File.expand_path('../boot', __FILE__)
    require "rails"
    load(File.expand_path('../heroku_env.rb', __FILE__))


## Done

`thor -T` should have your new deploy tasks.
