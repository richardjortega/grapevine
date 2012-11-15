require_relative '../jobs/opentable.rb'

namesapce :crawl do
	desc 'Check for new reviews from a series of OpenTable Links'
	task :new_reviews_opentable do
		#File that has list of opentable URLs
		filename = "#{Rails.root}/lib/jobs/opentable_multiplelinks.txt"
	end
end