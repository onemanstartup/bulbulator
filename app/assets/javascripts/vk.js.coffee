$ ->
  console.log("trigger ready")
  popupWindow_ = null
  interval_ = null
  vk_user = null

  $("#vk_authorize_link").click (e) ->
    selectedLink = ($ this)
    e.preventDefault()
    popupWindow_ = window.open $(this).attr('href'),'name','height=600,width=450'
    interval_ = window.setInterval(waitForPopupClose_, 80)
    false

  setupVK = ->
    $.ajax {
      type: "get"
      dataType: 'json'
      url: '/authorize_vk'
      complete: (res) ->
        vk_user = res.responseText
    }

  waitForPopupClose_ = ->
    if isPopupClosed_()
      popupWindow_ = null
      if interval_?
        clearInterval interval_
        interval_ = null
      setupVK()

  isPopupClosed_ = ->
    !popupWindow_ or popupWindow_.closed

  $("#albums_load_link").click (e) ->
    selectedLink = ($ this)
    e.preventDefault()
    $.ajax {
      beforeSend: ->
        $('body').addClass("loading")
      type: "get"
      dataType: 'json'
      url: '/albums'
      complete: (res) ->
        directives = {
          cover: {
            src: ->
              @src
          },
          album: {
            "data-aid": ->
              @aid
          }
        }
        renderUser($.parseJSON(res.responseText).user)
        $("#albums").render($.parseJSON(res.responseText).albums, directives)
        imgLoad = imagesLoaded( $("#albums") )
        imgLoad.on('done', (instance) ->
          $('body').removeClass("loading")
          $("#albums").css('opacity', '0').fadeTo(2500, 1,'swing')
        )
    }
    false

  renderUser = (data) ->
    directives = {
      avatar: {
        src: ->
          @photo_medium
      },
      fullname: {
        text: ->
          @first_name + " " + @last_name
      }
    }
    $("#user").render(data, directives)
    $("#user").css('opacity', '0').fadeTo(1500, 1,'swing')

  if document.cookie.replace(/(?:(?:^|.*;\s*)auth_token\s*\=\s*([^;]*).*$)|^.*$/, "$1")
    $("#albums_load_link").click()
  document.addEventListener("page:fetch", $('body').addClass("loading"))
  document.addEventListener("page:receive", $('body').removeClass("loading"))
  $('body').delegate( ".album", 'click', ->
    aid = $(@).data("aid")
    Turbolinks.visit("/get_album?aid="+ aid)
  )
