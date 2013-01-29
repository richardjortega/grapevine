class MailPreview < MailView
	def review_alert
		email = 'info+test@pickgrapevine.com'
		review = 'Lorem ipsum dolor sit amet, 
		consectetur adipisicing elit. Maiores dolorum 
		doloremque facilis quibusdam provident inventore 
		in mollitia temporibus minus culpa autem repudiandae 
		animi tenetur. Expedita perferendis asperiores 
		voluptatum maxime unde.'
		rating = 4.0
		source = 'tripadvisor'
		location = "Larkin's on the River"
		location_link = 'http://www.tripadvisor.com/Restaurant_Review-g54258-d829361-Reviews-Larkin_s_On_The_River-Greenville_South_Carolina.html'
		review_count = 2
		plan_type = 'paid'
		NotifyMailer.review_alert(email, review, rating, source, location, location_link, review_count, plan_type)
	end

	def follow_up_alert
		email = 'info+test@pickgrapevine.com'
		name = 'Bob Smith'
		body = 'Letting you know that we will be sending you something'
		body_part2 = 'very soon, I hope you buy our product.'
		location_link = 'http://www.bobsburgers.com'
		NotifyMailer.follow_up_alert(email, name, body, body_part2, location_link)
	end

	def submit_contact_us
		email = 'info+test@pickgrapevine.com'
		body = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maiores dolorum doloremque facilis quibusdam provident inventore in mollitia temporibus minus culpa autem repudiandae animi tenetur. Expedita perferendis asperiores voluptatum maxime unde.'
		name = "Bob's Burgers"
		subject = "Agnecy Inquiry"
		phone_number = '210.445.6655'
		NotifyMailer.submit_contact_us(email, name, body, subject, phone_number)
	end

	def free_signup
		user = User.first
		NotifyMailer.free_signup(user)
	end

	def paid_signup
		user = User.first
		NotifyMailer.paid_signup(user)
	end

	def update_grapevine_team
		user = User.first
		message = 'Alert message testing'
		NotifyMailer.update_grapevine_team(user, message)
	end

	def account_expired
		user = User.first
		NotifyMailer.account_expired(user)
	end

	def unsuccessfully_charged
		event = Stripe::Event.retrieve('evt_0qZ5sFpYMa8bqG')
		charge = event.data.object
		invoice_id = charge.invoice
		invoice = Stripe::Invoice.retrieve(invoice_id)
		user = User.first
		NotifyMailer.unsuccessfully_charged(invoice, user)
	end

	def successfully_charged
		event = Stripe::Event.retrieve('evt_17jcNUfa6QcZsk')
		charge = event.data.object
		invoice_id = charge.invoice
		invoice = Stripe::Invoice.retrieve(invoice_id)
		user = User.first
		NotifyMailer.successfully_charged(invoice, user)
	end
end