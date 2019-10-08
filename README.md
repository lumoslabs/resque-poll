[![Build Status](https://api.travis-ci.org/lumoslabs/resque-poll.png)](https://travis-ci.org/lumoslabs/resque-poll)

# resque-poll

resque-poll is a Rails engine that allows you to easily do long polling for Resque jobs. resque-poll depends on [resque-status](https://github.com/quirkey/resque-status).

## Installation

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
    poll = ResquePoll::Job.create(LongRunningMoveJob, {title: params[:title]})
    render json: poll.to_json
  end
end
```

resque-poll will fire events when the polling has completed (successfully or unsuccessfully). To make use of this, you can hook into the triggered events and take action on them. Any data passed back from the resque job will also be available to you in the response.

The following events are fired:

* `resque:poll:stopped` - fired when processing has finished successfully or unsuccessfully
* `resque:poll:success` - fired when processing has finished successfully
* `resque:poll:error`   - fired when processing has finished unsuccessfully

Continuing with our form from above:

```javascript
$('form')
  .bind('resque:poll:stopped', function(event, response) {
    console.log('Processing finished!');
  }).bind('resque:poll:success', function(event, response) {
    console.log('Processing successful!');
  }).bind('resque:poll:error', function(event, response) {
    console.log('Processing failed!');
  });
```

Since a common use case would be to enable/disable the submit button during the course of processing the background job, the `resque-poll-disable-with` attribute can be used to automatically disable/enable a button with a given value when processing has begun or completed.

```erb
<%= f.submit :'data-resque-poll-disable-with' => 'Creating...' %>
```

## Dependencies

resque-poll's latest version, 2.0.0, is dependent on Rails 4.0.0. It is not backwards-compatible with Rails 3. For the Rails 3 compatible version of resque-poll, please downgrade to 1.0.1.
