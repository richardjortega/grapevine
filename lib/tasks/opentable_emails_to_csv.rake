require_relative "../jobs/opentable.rb"

namespace :opentable do
	desc "OpenTable - Export CSV of All Locations with Emails"
	task :get_emails do
		run = OpenTableParser.new
		run.parser_engine
	end
end