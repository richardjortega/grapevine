# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("#credit-card input, #credit-card select").attr "disabled", false
  $("form:has(#credit-card)").submit ->
    form = this
    $("#user_submit").attr "disabled", true
    $("#credit-card input, #credit-card select").attr "name", ""
    $("#credit-card-errors").hide()
    unless $("#credit-card").is(":visible")
      $("#credit-card input, #credit-card select").attr "disabled", true
      return true
    card =
      number: $("#credit_card_number").val()
      expMonth: $("#_expiry_date_2i").val()
      expYear: $("#_expiry_date_1i").val()
      cvc: $("#cvv").val()

    Stripe.createToken card, (status, response) ->
      if status is 200
        $("#user_last_4_digits").val response.card.last4
        $("#user_stripe_token").val response.id
        form.submit()
      else
        $("#stripe-error-message").text response.error.message
        $("#credit-card-errors").show()
        $("#user_submit").attr "disabled", false

    false

  $("#change-card a").click ->
    $("#change-card").hide()
    $("#credit-card").show()
    $("#credit_card_number").focus()
    false