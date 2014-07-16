$ ->
  $(document).on 'change', '[name="work[parameters][target]"]', (e) ->
    $('[name="work[parameters][ignore][]"][type=checkbox]').each (_, e) ->
      $(e).prop 'disabled', false

    $(e.target).parent('td').next().find('input').prop 'disabled', true
