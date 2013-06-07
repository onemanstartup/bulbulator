$ ->
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
      type: "get"
      dataType: 'json'
      url: '/albums'
      complete: (res) ->
        directives = {
          cover: {
            src: ->
              @src
          }
        }
        $("#albums").render($.parseJSON(res.responseText).albums, directives)
        renderUser($.parseJSON(res.responseText).user)
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

