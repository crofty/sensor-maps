SM.Marker = SC.Object.extend
  init: ->
    @_super()
    lat = @get('lat')
    lon = @get('lon')
    @set('mapObject', new L.CircleMarker(new L.LatLng(lat,lon), radius: 5))
  bounds: ->
    latlng = @get('mapObject')._latlng
    new L.LatLngBounds(latlng,latlng)


SM.SelectableMarker = SM.Marker.extend
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

SM.HoverableMarker = SM.SelectableMarker.extend
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
