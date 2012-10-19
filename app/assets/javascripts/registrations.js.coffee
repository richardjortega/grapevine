jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('.payment-form').submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#credit_card_number').length
        subscription.processCard()
        false
      else
        true
  
  processCard: ->
    card =
      number: $('.credit-card-number').val()
      cvc: $('.card-cvc').val()
      exp_month: $('.card-expiry-month').val()
      exp_year: $('.card-expiry-year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#subscription_last_four').val(response.card.last4)
      $('#subscription_stripe_card_token').val(response.id)
      console.log("Haven't hit the conditional")

      $('.payment-form')[0].submit ->
        if $('input[type=submit]').attr('value') == '$30/month'
          console.log("we are in the conditional")
          $('#subscription_plan').attr('value') == '$30/month'
          false
        else
          true
    else
      $('.payment-errors').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)