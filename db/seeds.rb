require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

  # then, whenever you need to clean the DB
  DatabaseCleaner.clean


puts "Setting up default user login"
# user = User.create! :first_name => "Richard", :last_name => "Ortega", :email => "richard@pickgrapevine.com", :password => 'please', :password_confirmation => 'please', :last_4_digits => '1111'
# puts "New user created: #{user.first_name} #{user.last_name}"
user2 = User.create! :id => '2', :first_name => "Erik", :last_name => "Larson", :email => "erik@pickgrapevine.com", :password => 'please', :password_confirmation => 'please', :last_4_digits => '1111'
puts "New user created: #{user2.first_name} #{user2.last_name}"
