$(".cars").html("<%= escape_javascript(render("cars")) %>")

$(".cars_loading").hide()
$(".cars").show()
