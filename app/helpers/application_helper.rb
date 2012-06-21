module ApplicationHelper
	# to help Devise errors message play nicely with Twitter Bootstrap
	def display_flash(name,msg)
		case name.to_s
		when "notice" then
			content_tag :div, msg, :class => "alert success"
		when "alert" then
			content_tag :div, msg, :class => "alert warning"
		else
			content_tag :div, msg, :class => "alert info"
		end
	end
end
