# Review test data (only here as an example reference)
# Review(id: integer, location_id: integer, source_id: integer, author: string, author_url: string, comment: string, post_date: date, rating: decimal, title: string, management_response: string, verified: boolean, rating_description: string, url: string, created_at: datetime, updated_at: datetime) 
# review1 = Review.find_or_create_by_comment! comment: 'I love this place so much', location_id: 14, source_id: 1, author: 'Richard Ortega', author_url: '', post_date: Date.today, rating: 5.0, title: 'Amazing time at this place'
# puts "Inserted review from #{review1.author}"
# review2 = Review.find_or_create_by_comment! comment: 'I was here for a work function on site at the hotel. I found the food within the hotel to be pretty good. Our breakfast, lunch and snacks were provided and there was always an array of things to choose from to keep everyone happy.  I felt like the workshop accommodations were quite nice.

# I really liked my room.  The layout and ambiance of the hotel was also very nice. The location is great and made access to other dining and sites very easy.  My only complaint about the room would be that the bed was not that comfortable, not enough to ruin a night sleep though. 

# I found the customer service here to be very good. The staff was always helpful, friendly and pleasant.', location_id: 12, source_id: 1, author: 'Sarah P.', author_url: 'http://www.yelp.com/user_details?userid=WREJotFyh0MF2ImGpNSjMg', post_date: Date.strptime('8/26/2012', '%m/%d/%Y'), rating: 4.0, title: ''
# puts "Inserted review from #{review2.author}"

# # Vine(id: integer, source_id: integer, location_id: integer, source_location_uri: string, overall_rating: decimal, created_at: datetime, updated_at: datetime) 
# vine1 = Vine.find_or_create_by_source_location_uri! source_location_uri: 'las-ramblas-san-antonio', source_id: 1, location_id: 14, overall_rating: 4.5
# puts "Inserted vine to #{vine1.source_location_uri}"
# vine2 = Vine.find_or_create_by_source_location_uri! source_location_uri: 'hotel-contessa-san-antonio', source_id: 1, location_id: 12, overall_rating: 4.0
# puts "Inserted vine to #{vine2.source_location_uri}"
# vine3 = Vine.find_or_create_by_source_location_uri! source_location_uri: 'Hotel_Review-g60956-d570285-Reviews-Hotel_Contessa-San_Antonio_Texas.html', source_id: 4, location_id: 12, overall_rating: 4.0
# puts "Inserted vine to #{vine3.source_location_uri}"
