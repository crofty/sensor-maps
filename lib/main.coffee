require('sproutcore')
require('sensor-maps/libs/leaflet')
# Sensor Maps namespace
SM = {}
@SM = SM
SM.CLOUDMADE_API_KEY = 'a33ede6a9595478ba1025f20398c0341'

require('sensor-maps/polyline')
require('sensor-maps/marker')
require('sensor-maps/vehicle')



SM.Map = SC.Object.extend
  init: ->
    @_super()
    map = new L.Map @get('divId')
    cloudmadeTiles = new L.TileLayer "http://{s}.tile.cloudmade.com/#{SM.CLOUDMADE_API_KEY}/998/256/{z}/{x}/{y}.png",
      maxZoom: 18
    map.addLayer cloudmadeTiles
    map.attributionControl.setPrefix('')
    @set('mapObject', map)
    @set('objects',[])
  addObject: (object) ->
    @get('objects').push object
    @mapObject.addLayer(object.mapObject)
    this
  fitBounds: (bounds) ->
    @get('mapObject').fitBounds(bounds)
  fitAllObjects: ->
    bounds = new L.LatLngBounds()
    for object in @objects
      bounds.extend object.bounds().getSouthWest()
      bounds.extend object.bounds().getNorthEast()
    @fitBounds bounds

