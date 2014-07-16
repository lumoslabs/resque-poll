$ ->
  $.fn.resquePoll = (options) ->
    opts = $.extend({}, $.fn.resquePoll.defaults, options)
    $this = this
    poll = setInterval(->
      $.getJSON opts.url, (resp) ->
        return if resp.status is "queued"
        clearInterval poll
        switch resp.status
          when "completed"
            $this.trigger "resque:poll:stopped"
            $this.trigger "resque:poll:success", resp
          when "failed"
            $this.trigger "resque:poll:stopped"
            $this.trigger "resque:poll:error", resp
    , opts.interval)
    this

  $.fn.resquePoll.defaults = interval: 2000

  $(document).on "resque:poll:stopped", "form[data-resque-poll]", ->
    $(this).find("[data-resque-poll-disable-with]").each (i) ->
      $this = $(this)
      $this.removeAttr("disabled").attr "value", $this.data("resque-poll-enable-with")

  $(document).on "ajax:before", "form[data-resque-poll]", ->
    $(this).find("[data-resque-poll-disable-with]").each (i) ->
      $this = $(this)
      $this.data("resque-poll-enable-with", $this.val()).attr("value", $this.data("resque-poll-disable-with")).attr "disabled", "disabled"

  $(document).on "ajax:success", "form[data-resque-poll]", (data, status, xhr) ->
    $(this).resquePoll url: status.poll if status.poll
