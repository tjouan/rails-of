$ ->
  do (d = document, t = 'script') ->
    z = $zopim = (c) ->
      z._.push(c)

    z.set = (o) ->
      z.set._.push(o)

    z._     = []
    z.set._ = []

    e     = d.createElement(t)
    e.src = '//v2.zopim.com/?FIXME'
    s     = d.getElementsByTagName(t)[0]
    s.parentNode.insertBefore(e, s)
