#= require spec_helper
#= require resque_poll/poller

describe 'ResquePoller', ->
  it 'exists', -> expect(ResquePoller).to.exist

  it 'has a default timeout value', ->
    expect(ResquePoller.INTERVAL).to.be.above(0)

  describe 'new', ->
    it 'sets the poll url', ->
      poll = new ResquePoller(url: '/some/url')
      expect(poll.url).to.equal('/some/url')

    it 'sets the element', ->
      elem = $(document.createElement('div'))
      poll = new ResquePoller(elem: elem)
      expect(poll.$elem).to.equal(elem)

  describe '_handleResponse', ->
    beforeEach ->
      @elem = $(document.createElement('div'))
      @poll = new ResquePoller(elem: @elem)
      @poll.interval = window.setInterval(->)
      sinon.spy(@elem, 'trigger')

    describe 'when the status is queued', ->
      beforeEach -> @status = {status: 'queued'}

      it 'does not trigger any events', ->
        @poll._handleResponse(@status)
        expect(@elem.trigger).not.to.have.been.called

      it 'does not clear the interval', ->
        sinon.stub(window, 'clearInterval')
        @poll._handleResponse(@status)
        expect(window.clearInterval).not.to.have.been.called
        window.clearInterval.restore()

    describe 'when the status is completed', ->
      beforeEach -> @status = {status: 'completed'}

      it 'clears the interval', ->
        sinon.stub(window, 'clearInterval')
        @poll._handleResponse(@status)
        expect(window.clearInterval).to.have.been.called
        window.clearInterval.restore()

      it 'triggers a resque:poll:stopped event', ->
        @poll._handleResponse(@status)
        expect(@elem.trigger).to.have.been.calledWith('resque:poll:stopped', @status)

      it 'triggers a resque:poll:success event', ->
        @poll._handleResponse(@status)
        expect(@elem.trigger).to.have.been.calledWith('resque:poll:success', @status)

    describe 'when the status is failed', ->
      beforeEach -> @status = {status: 'failed'}

      it 'clears the interval', ->
        sinon.stub(window, 'clearInterval')
        @poll._handleResponse(@status)
        expect(window.clearInterval).to.have.been.called
        window.clearInterval.restore()

      it 'triggers a resque:poll:stopped event', ->
        @poll._handleResponse(@status)
        expect(@elem.trigger).to.have.been.calledWith('resque:poll:stopped', @status)

      it 'triggers a resque:poll:error event', ->
        @poll._handleResponse(@status)
        expect(@elem.trigger).to.have.been.calledWith('resque:poll:error', @status)

  describe 'when an AJAX request is submitted on a bound form', ->
    beforeEach ->
      $('body').html(JST['support/templates/resque_poll']())
      $('form').trigger('ajax:before')

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
