window.Wait =
  for: (callback, done) ->
    time = 0
    timeout = 2000
    interval = 100

    (retry = ->
      time += interval
      try
        callback()
      catch err
        if time < timeout
          setTimeout(retry, interval)
          return
        else
          throw err
      done()
    )()
