class ResquePoller
  @INTERVAL: 2000

  constructor: (opts) ->
    @$elem    = opts.elem
    @url      = opts.url
    @interval = setInterval(@_poll, ResquePoller.INTERVAL)

  # private

  _poll: => $.getJSON @url, (resp) => @_handleResponse(resp)

  _handleResponse: (resp) ->
    return if resp.status is 'queued'
    clearInterval @interval if @interval
    switch resp.status
      when 'completed'
        @$elem.trigger 'resque:poll:stopped', resp
        @$elem.trigger 'resque:poll:success', resp
      when 'failed'
        @$elem.trigger 'resque:poll:stopped', resp
        @$elem.trigger 'resque:poll:error', resp

window.ResquePoller = ResquePoller

$ ->
  $(document).on 'ajax:before', 'form[data-resque-poll]', ->
    $(this).find('[data-resque-poll-disable-with]').each (i) ->
      $(this)
        .data('resque-poll-enable-with', $(this).val())
        .attr('disabled', 'disabled')
        .attr('value', $(this).data('resque-poll-disable-with'))

  $(document).on 'resque:poll:stopped', 'form[data-resque-poll]', ->
    $(this).find('[data-resque-poll-disable-with]').each (i) ->
      $(this)
        .removeAttr('disabled')
        .attr('value', $(this).data('resque-poll-enable-with'))

  $(document).on 'ajax:success', 'form[data-resque-poll]', (data, status, xhr) ->
    new ResquePoller(elem: $(this), url: status.poll) if status.poll
