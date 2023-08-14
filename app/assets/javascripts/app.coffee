window.App =
  # Convert all dates from UTC to local time.
  convertUtcDates: ->
    utcDates = $('[data-timezone-converted="false"]')
    if utcDates.length > 0
      App.convertUtcToLocalTime date for date in utcDates
      console.log 'UTC dates converted.'

  # Convert one UTC date to local time.
  convertUtcToLocalTime: (date) ->
    date = $(date)
    utcTime = date.data('utc-time')
    format = date.data('format')

    newDate = moment.utc(utcTime, 'YYYY-MM-DD HH:mm:ss').local()

    if format == 'stacked'
      formattedDate = newDate.format('MMM Do, YYYY<br>h:mm a')
    else if format == 'long'
      formattedDate = newDate.format('MMM Do, YYYY @ h:mm a')
    else
      formattedDate = newDate.format('MMM Do, h:mm a')

    date.html(formattedDate)
    date.attr('data-timezone-converted', 'true')

  # Set up the datepicker plugin.
  attachDatepicker: ->
    date_inputs = $('[data-type="date"]')
    if date_inputs.length > 0
      date_inputs.datepicker(format: 'yyyy-mm-dd', autoclose: true)
      console.log 'Datepicker attached.'

  # Set up the tablesorter plugin.
  # Sort on the second column, in ascending order.
  attachTablesorter: ->
    tables = $('[data-sort=table]')
    if tables.length > 0
      tables.tablesorter sortList: []
      console.log 'Tablesorter attached.'

  # Set up 'copy to clipboard' buttons.
  attachClipboardEvents: ->
    clipboard_buttons = $('[data-clipboard-copyable=true]')
    if clipboard_buttons.length > 0
      App.attachButtonCopyEvent button for button in clipboard_buttons
      console.log 'Clipboard button events attached.'

  attachButtonCopyEvent: (button) ->
    $(button).off "click"
    $(button).on "click", (event) ->
      event.preventDefault()
      App.copyButtonTextToClipboard button

  disableButtonCopyEvent: (button) ->
    $(button).off "click"
    $(button).on "click", (event) ->
      event.preventDefault()

  showButtonCopyEvent: (button) ->
    App.disableButtonCopyEvent(button)
    $button = $(button)
    $button.addClass('disabled')
    $button.find('i').removeClass('fa-clipboard').addClass('fa-check-circle-o')
    $button.find('.label').html('Copied')
    setTimeout App.resetCopyButton, 2000, button

  resetCopyButton: (button) ->
    $button = $(button)
    $label = $button.find('.label')
    original_label_text = $button.data('original-label')
    $label.html(original_label_text)
    $button.find('i').removeClass('fa-check-circle-o').addClass('fa-clipboard')
    $button.removeClass('disabled')
    App.attachButtonCopyEvent(button)

  copyButtonTextToClipboard: (button) ->
    text = $(button).data('clipboard-text')
    textArea = App.createHiddenSelectedTextArea(text)
    try
      successful = document.execCommand('copy')
      console.log 'Copied "' + text + '" to clipboad.'
      App.showButtonCopyEvent(button)
      # App.showSuccessAlert "<i>#{text}</i> has been copied to your clipboard."
      # setTimeout App.hideSuccessAlert, 5000
    catch err
      console.log 'Unable to copy to clipboard.'
    document.body.removeChild textArea

  # Check out: https://stackoverflow.com/questions/400212/how-do-i-copy-to-the-clipboard-in-javascript
  createHiddenSelectedTextArea: (text) ->
    textArea = document.createElement('textarea')
    textArea.style.position = 'fixed'
    textArea.style.top = 0
    textArea.style.left = 0
    textArea.style.width = '2em'
    textArea.style.height = '2em'
    textArea.style.padding = 0
    textArea.style.border = 'none'
    textArea.style.outline = 'none'
    textArea.style.boxShadow = 'none'
    textArea.style.background = 'transparent'
    textArea.value = text
    document.body.appendChild textArea
    textArea.select()
    return textArea

  initializeTooltips: ->
    tooltips = $('[data-tooltip=true]')
    if tooltips.length > 0
      tooltips.tooltip()
      console.log 'Tooltips added.'

  attachCheckboxMultiClickEvents: ->
    multiclickCheckboxes = $('.checkbox-multi-click')

    if multiclickCheckboxes.length > 0
      lastChecked = null
      $('.checkbox-multi-click').click (e) ->
        if !lastChecked
          lastChecked = this
          return

        if e.shiftKey
          from = multiclickCheckboxes.index(this)
          to = multiclickCheckboxes.index(lastChecked)
          start = Math.min(from, to)
          end = Math.max(from, to) + 1
          multiclickCheckboxes.slice(start, end).filter(':not(:disabled)').prop 'checked', lastChecked.checked

        lastChecked = this
        return
      console.log 'Multi-click checkbox events added'

  # attachAlertPopupEvents: ->
  #   alert_buttons = $('#alert-popups .alert button')
  #   if alert_buttons.length > 0
  #     App.makeAlertHideable button for button in alert_buttons
  #     console.log 'Alert popup events attached.'

  # showSuccessAlert: (message) ->
  #   success_alert = $('#success-popup')
  #   success_alert.hide()
  #   alert_text = $(success_alert).find('.text')
  #   alert_text.html(message)
  #   success_alert.show()

  # hideSuccessAlert: ->
  #   success_alert = $('#success-popup')
  #   success_alert.hide()

  # makeAlertHideable: (button) ->
  #   $(button).off "click"
  #   $(button).on "click", (event) ->
  #     event.preventDefault()
  #     console.log 'Clicked alert close button.'
  #     $(this).parent().hide()
