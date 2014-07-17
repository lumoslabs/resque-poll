# resque-poll

resque-poll is a Rails engine that allows you to easily do long polling for Resque jobs. resque-poll depends on [resque-status](https://github.com/quirkey/resque-status).

## Usage

Include resque-poll in your Gemfile:

```ruby
gem 'resque-poll'
```

Mount the engine in your `routes.rb`:

```ruby
mount ResquePoll::Engine => '/resque_poll'
```

Require the javascript files & the dependencies inyour application.js javascript file (requires Asset Pipeline):

```js
//= require jquery
//= require resque_poll
```

## Usage

In a form, the `data-resque-poll` attribute to your form tag:

```erb
<%= form_for @movie, html: { data: { 'resque-poll' => true } } do |f| %>
  <%= f.input :title %>
  <%= f.submit %>
```

Your controller can then use ResquePoll to return the appropriate response to begin polling:

```ruby
class MoviesController < ApplicationController
  def create
    poll = ResquePoll.create(LongRunningMoveJob, {title: params[:title]})
    render json: poll.to_json
  end
end
