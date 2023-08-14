# This turbolinks event fires when a page loads for the first time and when any
# subsequent pages are loaded. Use this in place of document.ready.
document.addEventListener 'turbolinks:load', ->
  console.log 'Page loaded.'

  App.convertUtcDates()
  App.attachDatepicker()
  App.attachTablesorter()
  App.attachClipboardEvents()
  # App.attachAlertPopupEvents()
  App.initializeTooltips()
  App.attachCheckboxMultiClickEvents()
