jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

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
      $('.payment-form').prepend('<span id="payment-errors"></span>')
      $('#payment-errors').text(response.error.message)
      $('html,body').animate({scrollTop: $('#payment-errors').offset().top},'slow')
      # re-enable the submit button
      $('input[type=submit]').attr('disabled', false)
  