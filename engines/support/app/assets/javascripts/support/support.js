//var $jq = jQuery.noConflict();

$(document).ready(function(){
  $('#reply_template').on('select',function(e){
    var newValue = $('#reply_message').val() + $(this).val();
    $('#reply_message').val(newValue);
  });

  $(document).on('reload_form form', function(e){
    var form = $(e.target)
    $.get(form.data('reload-url'), function(data){
      form.replaceWith(data)
    })
  });

  $(document)
    .on('ajax:success #new_ticket_tag', function(e, data, xhr){
      $('#tags_form').trigger('reload_form')
    })
    .on('ajax:beforeSend #new_ticket_tag', function(e){
      $(e.target).find(':input').each(function(i, e){
        e.disabled = true
      })
    })
    .on('ajax:complete #new_ticket_tag', function(e){
      $(e.target).find(':input').each(function(i, e){
        if (e.type != 'submit') {
          e.value = ""
        }
        e.disabled = false
      })
    })

  $('div.toggle-box').on('click > div.toggle', function(e){
    var box = $(e.target).parents('div.toggle-box:first')
    box.find('> div.object').toggle()
  })

  $('#reply-template-maker').on('click', function(e){
    var data = $('#reply_message').val();
    var url = $('#reply-template-maker').attr("href") + '?' + `reply_template[message_${window.locale}]=` + data;
    window.open(url, '_blank')
    return false
  })
});
