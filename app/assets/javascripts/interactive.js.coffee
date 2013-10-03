$ ->
	$(':checkbox').click ->
    $(this).closest('form').submit()