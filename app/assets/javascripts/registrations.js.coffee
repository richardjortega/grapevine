jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#payment-form').submit ->
      # disable the submit button to prevent repeated clicks
      $('input[type=submit]').attr('disabled', 'disabled')
      if $('#credit_card_number').length
        subscription.processCard()
        false # submit from callback
      else
        true
  
  processCard: ->
    card =
      number: $('.credit-card-number').val()
      cvc: $('.card-cvc').val()
      exp_month: $('.card-expiry-month').val()
      exp_year: $('.card-expiry-year').val()
    # createToken returns immediately - the supplied callback submits the form if there are no errors
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      form$ = $('#payment-form')
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />")
      #$('#subscription_last_four').val(response.card.last4)
      #$('#subscription_stripe_card_token').val(response.id)
      
      # and submit
      form$.get(0).submit()


      #$('input[name=pick-plan]').attr('id')
      #$('#payment-form')[0].submit()
    else
      # re-enable the submit button
      $('input[type=submit]').removeAttr('disabled')
      # show the errors on the form
      $('.payment-errors').text(response.error.message)