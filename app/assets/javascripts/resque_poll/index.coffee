#= require_tree .

$ ->
  $(document).on 'ajax:success', 'form[data-resque-poll]', (data, status, xhr) ->
    new ResquePoller(elem: $(this), url: status.poll) if status.poll
