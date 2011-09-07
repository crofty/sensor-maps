SM.Polyline = SC.Object.extend
  init: ->
    @_super()
    @mapObject = new L.Polyline(@_latlngs())
  _latlngs: ->
    points = @getPath('points.content') || @get('points') || [[51.509,-0.08]] # Need this for now becuase leaflet doesn't let you create polylines with an empty array
    latlngs = (new L.LatLng(point[0],point[1]) for point in points)
    latlngs
  bounds: ->
    new L.LatLngBounds(@mapObject._latlngs)
  pointsDidChange: (->
    @mapObject.setLatLngs @_latlngs()
  ).observes('points.length')

SM.SelectablePolyline = SM.Polyline.extend
  init: ->
    @_super()
    @bindEvents()
  selected: false
  bindEvents: ->
    @get('mapObject').on 'click', => @set('selected',!@get('selected'))
  stateDidChange: ( ->
    @get('mapObject').setStyle( if @get('state') == 'selected' then @selectedStyle else @defaultStyle)
  ).observes('state')
  state: ( ->
    return 'selected' if @get('selected')
  ).property('selected')
  defaultStyle: {color: 'blue', opacity: 0.5}
  selectedStyle: {color: 'green'}

SM.HoverablePolyline = SM.SelectablePolyline.extend
  hover: false
  bindEvents: ->
    @get('mapObject').on 'mouseover', => @set('hover', true)
    @get('mapObject').on 'mouseout',  => @set('hover', false)
    @_super()
  stateDidChange: ( ->
    @get('mapObject').setStyle(switch @get('state')
      when 'selected'
        @selectedStyle
      when 'hover'
        @hoverStyle
      else
        @defaultStyle
    )
  ).observes('state')
  state: ( ->
    return 'selected' if @get('selected')
    return 'hover' if @get('hover')
  ).property('hover', 'selected')
  hoverStyle: {color: 'red', opacity: 0.8}
