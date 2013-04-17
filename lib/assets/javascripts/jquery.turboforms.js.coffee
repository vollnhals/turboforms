$ = jQuery
TL = Turbolinks

$.fn.extend
  turboForms: (options) ->
    return @each (i, el) ->
      createDocument = TL.browserCompatibleDocumentParser()
      el = $(el)

      el.data('remote', true)
      el.data('type', 'html')

      el.bind 'ajax:beforeSend', (event, data, status, xhr) ->
        TL.cacheCurrentPage()
        TL.triggerEvent 'page:fetch'
        true

      el.bind 'ajax:complete', (event, xhr, status) ->
        doc = createDocument xhr.responseText
        location = xhr.getResponseHeader 'X-XHR-Current-Location'

        if location
          url = "#{document.location.protocol}//#{document.location.host}#{location}"
          TL.reflectNewUrl url

        TL.changePage TL.extractTitleAndBody(doc)...

        TL.resetScrollPosition()
        TL.triggerEvent 'page:load'

        true

$ ->
  $('form[data-turboform]').turboForms()
