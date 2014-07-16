#= require spec_helper
#= require resque_poll/poll

describe 'jQuery.resquePoll', ->
  beforeEach -> $('body').html(JST['support/templates/resque_poll']())

  it 'exists', -> expect($(document).resquePoll).to.exist

  it 'returns the element', ->
    expect($(document).resquePoll()).to.be($(document))

  it 'has a default timeout value', ->
    expect($(document).resquePoll.defaults.interval).to.equal(2000)

  describe 'when polling a job that is still queued', ->
    beforeEach ->
      sinon.stub($, 'getJSON').yields({status: 'queued'})

    afterEach ->
      $.getJSON.restore()
      window.clearInterval.restore()

    it 'does not clear the interval', ->
      sinon.stub(window, 'clearInterval')
      $('form').resquePoll(url: '/callback', interval: 5)
      expect(window.clearInterval).not.to.have.been.called

  describe 'when polling a job that failed', ->
    beforeEach ->
      sinon.stub($, 'getJSON').yields({status: 'failed'})
      sinon.spy(window, 'clearInterval')

    afterEach ->
      $.getJSON.restore()
      window.clearInterval.restore()

    it 'clears the interval', (done) ->
      $('form').resquePoll(url: '/callback', interval: 5)
      Wait.for ->
        expect(window.clearInterval).to.have.been.called
      , done

    it 'triggers a resque:poll:stopped event', (done) ->
      sinon.spy($.fn, 'trigger')
      $('form').resquePoll(url: '/callback', interval: 5)
      Wait.for ->
        expect($.fn.trigger).to.have.been.calledWith('resque:poll:stopped')
        $.fn.trigger.restore()
      , done

    it 'triggers a resque:poll:error event', (done) ->
      sinon.spy($.fn, 'trigger')
      $('form').resquePoll(url: '/callback', interval: 5)
      Wait.for ->
        expect($.fn.trigger).to.have.been.calledWithMatch('resque:poll:error', {status: 'failed'})
        $.fn.trigger.restore()
      , done

  describe 'when polling a job that succeeded', ->
    beforeEach ->
      sinon.stub($, 'getJSON').yields({status: 'completed'})

    afterEach ->
      $.getJSON.restore()

    it 'clears the interval', (done) ->
      sinon.spy(window, 'clearInterval')
      $('form').resquePoll(url: '/callback', interval: 5)
      Wait.for ->
        expect(window.clearInterval).to.have.been.called
        window.clearInterval.restore()
      , done

    it 'triggers a resque:poll:stopped event', (done) ->
      sinon.spy($.fn, 'trigger')
      $('form').resquePoll(url: '/callback', interval: 5)
      Wait.for ->
        expect($.fn.trigger).to.have.been.calledWith('resque:poll:stopped')
        $.fn.trigger.restore()
      , done

    it 'triggers a resque:poll:success event', (done) ->
      sinon.spy($.fn, 'trigger')
      $('form').resquePoll(url: '/callback', interval: 5)
      Wait.for ->
        expect($.fn.trigger).to.have.been.calledWithMatch('resque:poll:success', {status: 'completed'})
        $.fn.trigger.restore()
      , done

  describe 'when an AJAX request is submitted on a bound form', ->
    beforeEach -> $('form').trigger('ajax:before')

    it 'disables any resque-poll-disable-with elements', ->
      expect($('#submit').attr('disabled')).to.equal('disabled')

    it 'replaces the value of resque-poll-disable-with elements with their disabled value', ->
      expect($('#submit').val()).to.equal('Disabled')

    describe 'and then a poll stopped event is triggered', ->
      beforeEach ->
        $('form').trigger('resque:poll:stopped')

      it 'enables any resque-poll-disable-with elements', ->
        expect($('#submit').attr('disabled')).to.be.undefined

      it 'replaces the value of resque-poll-disable-with elements with their enabled value', ->
        expect($('#submit').val()).to.equal('Enabled')

  describe 'when an AJAX request is complete on a bound form', ->
    afterEach -> $.fn.resquePoll.restore()

    it 'starts polling the job', ->
      sinon.stub($.fn, 'resquePoll')
      $('form').trigger('ajax:success', poll: '/blah')
      expect($.fn.resquePoll).to.have.been.calledWith(url: '/blah')
