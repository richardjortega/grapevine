ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => 'Grapevine Dashboard' do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span "This our dashboard... it's literally awsum"
      end
    end

    br
    
    # Sample data points we may want to collect
    columns do
        column do
            panel 'Total Users' do
                "#{User.all.count}"
            end
            panel 'Recent Users' do
                ul do
                    User.last(5).map do |user|
                        li link_to(user.email, admin_user_path(user))
                    end
                end
            end
        end

        column do
            panel 'Total Locations' do
                "#{Location.all.count}"
            end
             panel 'Recent Locations' do
                ul do
                    Location.last(5).map do |location|
                        li link_to(location.name, admin_location_path(location))
                    end
                end
            end
        end

        column do
            panel 'Total Reviews' do
                "#{Review.all.count}"
            end
             panel 'Recent Reviews' do
                ul do
                    Review.last(5).map do |review|
                        comment = truncate("#{review.comment}", :length => 50)
                        li link_to(comment, admin_review_path(review))
                    end
                end
            end
        end
    end
    
  end # content
end
