# This plugin dynamically adjusts the height of a textarea to its contents.
# Copyright 2012 - 2013 by Corin Langosch.

$ ->
  class Autogrow
    constructor: (textarea, settings) ->
      @el = $(textarea)
      @el.css('overflow', 'hidden')
      @setMinHeight()
      @createBox()
      @createEventHandlers()
      @update()

    setMinHeight: =>
      minHeight = parseInt(@el.css('minHeight'))
      return if minHeight > 0
      rows = parseInt(@el.attr('rows'))
      lineHeight = parseInt(@el.css('lineHeight'))
      return unless rows > 0 && lineHeight > 0
      @el.css('minHeight', "#{rows * lineHeight}px")

    createBox: =>
      @box = $('<div>').css
        position: 'absolute'
        whiteSpace: 'pre-wrap'
        wordWrap: 'break-word'
        overflow: 'hidden'
        display: 'none'
      @box.appendTo(document.body)

    updateBoxMetrics: =>
      @box.css
        minHeight: @el.css('minHeight')
        maxHeight: @el.css('maxHeight')
        fontSize: @el.css('fontSize')
        fontFamily: @el.css('fontFamily')
        fontWeight: @el.css('fontWeight')
        lineHeight: @el.css('lineHeight')
      @box.width(@el.width())

    createEventHandlers: =>
      @el.change(@update).keyup(@update).keydown(@update)
      @el.bind("remove.autogrow", => @box.remove())

    update: =>
      @updateBoxMetrics()
      @box.text(@el.val() + "\n")
      @el.height(@box.height())

  $.fn.autogrow = (settings) ->
    @.each -> new Autogrow(@, settings)
    @

