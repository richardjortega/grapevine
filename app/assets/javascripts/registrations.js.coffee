jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()
  
  # add custom rules for credit card validating
  jQuery.validator.addMethod "cardNumber", Stripe.validateCardNumber, "Please enter a valid card number"
  jQuery.validator.addMethod "cardCVC", Stripe.validateCVC, "Please enter a valid security code"
  jQuery.validator.addMethod "cardExpiry", (->
    Stripe.validateExpiry $("#card-expiry-month").val(), $("#card-expiry-year").val()
  ), "Please enter a valid expiration"

  # We use the jQuery validate plugin to validate required params on submit
  $("#credit-card").validate
    submitHandler: submit
    rules:
      "card-cvc":
        cardCVC: true
        required: true

      "card-number":
        cardNumber: true
        required: true

      "card-expiry-year": "cardExpiry" # we don't validate month separately

subscription =
  setupForm: ->
    $('#payment-form').submit ->
      # disable the submit button to prevent repeated clicks
      $('input[type=submit]').attr('disabled', true)
      if $('#credit-card-number').length
        subscription.processCard()
        false # submit from callback
      else
        true
  
  processCard: ->
    card =
      number: $('#credit-card-number').val()
      cvc: $('#card-cvc').val()
      exp_month: $('#card-expiry-month').val()
      exp_year: $('#card-expiry-year').val()
      name: $('#name-on-card').val()

    # createToken returns immediately - the supplied callback submits the form if there are no errors
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#subscription_last_four').val(response.card.last4)
      $('#subscription_stripe_card_token').val(response.id)
      $('#payment-form')[0].submit()
    else
      # show the errors on the form
      $('.payment-errors').text(response.error.message)
      # re-enable the submit button
      $('input[type=submit]').attr('disabled', false)
  