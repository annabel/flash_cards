$(document).ready(function() {
  $("#login_form").hide();
  $("#signup_form").hide();
  $("#login_button").on("click", function() {
    $("#signup_form").hide();
    $("#login_form").show();
  });
  $("#signup_button").on("click", function() {
    $("#login_form").hide();
    $("#signup_form").show();
  });
});
