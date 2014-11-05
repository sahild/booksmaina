#= require active_admin/base

admin =
  init: ->
    admin.set_admin_editable_events()
    return

  set_admin_editable_events: ->
    $(document).on "keypress",".admin-editable", (e) ->
      $(e.currentTarget).hide()  if e.keyCode is 27
      if e.keyCode is 13
        path = $(e.currentTarget).attr("data-path")
        attr = $(e.currentTarget).attr("data-attr")
        resource_id = $(e.currentTarget).attr("data-resource-id")
        val = $(e.currentTarget).val()
        val = $.trim(val)
        val = "&nbsp;"  if val.length is 0
        $("div#" + $(e.currentTarget).attr("id")).html val
        $(e.currentTarget).hide()
        payload = {}
        resource_class = path.slice(0, -1) # e.g. path = meters, resource_class = meter
        payload[resource_class] = {}
        payload[resource_class][attr] = val
        $.ajax
          url: "/admin/" + path + "/" + resource_id
          type: "PUT"
          data: payload
          success: (response) ->
            console.log response
            return

      return

    $(document).on "blur",".admin-editable", (e) ->
      $(e.currentTarget).hide()
      return

    $(document).on "dblclick",".editable_text_column", (e) ->
      id = $(this).attr("id")
      textBox = $("input#" + id)
      $(textBox).width($(this).width() + 4).height $(this).height() + 4
      $(textBox).css
        top: ($(this).offset().top - 2)
        left: ($(this).offset().left - 2)
        position: "absolute"
        
      val = $(this).html()
      val = ""  if val is "&nbsp;"
      $(textBox).val val
      $(textBox).show()
      $(textBox).focus()
      return

$(document).ready ->
  admin.init()
  return
