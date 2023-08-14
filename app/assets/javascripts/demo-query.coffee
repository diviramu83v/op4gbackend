window.App.attachDemoQueryFilterRender = ->
  $('body').on('ajax:success', '[data-demo-filter="button"], [data-demo-filter="form"]', (event) ->
    if window.pendingRequests < 1
      throw "'window.pendingRequest' is expected but missing."
    if window.pendingRequests == 1
      [data, status, xhr] = event.detail

      response = JSON.parse(xhr.response)

      if response['filter']
        $("div[data-partial='demo-active-filter']").html(response['filter'])
      if response['traffic']
        $("div[data-partial='demo-traffic']").html(response['traffic'])
      if response['options']
        $("div[data-partial='demo-filter-options']").html(response['options'])
      if response['zip_codes']
        $("div[data-partial='demo-zip-codes']").html(response['zip_codes'])

    window.pendingRequests--
  )#.on "ajax:error", (event) ->

  $('body').on('click', '[data-demo-filter="button"]', (event) ->
    siblingDropdown = $(this).siblings("select")[0]
    if siblingDropdown && (siblingDropdown.selectedIndex == 0)
      # this button belongs to a dropdown with no selection
      return

    if $(this).is("a")
      $(this).hide()

    if window.pendingRequests < 0
      throw "'window.pendingRequests' should never be negative."
    if typeof window.pendingRequests == 'undefined'
      window.pendingRequests = 1
    else
      window.pendingRequests++

    $('#panelist-count').html('<i class="fa fa-spinner fa-spin"></i>')
  )
