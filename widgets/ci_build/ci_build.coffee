class Dashing.CiBuild extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue
  @accessor 'bgColor', ->
    if @get('currentResult') == "Success"
      "#00B85C"
    else if @get('currentResult') == "Override"
      "#00B85C"
    else if @get('currentResult') == "Failure"
      "#D26771"
    else if @get('currentResult') == "Building"
      "#9c4274"
    else if @get('currentResult') == "PREBUILD"
      "#ff9618"
    else
      "#999"

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".jenkins-build").val(value).trigger('change')

  ready: ->
    $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn()

  onData: (data) ->
    if data.currentResult isnt data.lastResult
      $(@node).fadeOut().css('background-color', @get('bgColor')).fadeIn()
