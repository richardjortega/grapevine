ActiveAdmin.register_page "Help" do

  menu :label => 'Help'

  content :title => 'Help Resources' do
    
    h2 'Examples for setting up Vines'
    h3 'Example using Zinc Bistro & Wine Bar in San Antonio TX'

    table :cellspacing => '0', :style => 'border:1px solid black; border-collapse:collapse; table-layout:fixed; word-wrap:break-word;' do
        tr do
            th :style => 'border:1px solid black;' do
             'Crawl Site'
            end
            th :style => 'border:1px solid black;' do
             'Location Link'
            end
            th :style => 'border:1px solid black;' do
             'Required Source Location URI'
            end
            th :style => 'border:1px solid black;' do 
             'Notes'
            end
        end
        tr do
            td :style => 'border:1px solid black;' do
                'OpenTable'
            end
            td :style => 'border:1px solid black;' do
                "http://www.opentable.com/zinc-bistro-and-wine-bar"
            end
            td :style => 'border:1px solid black;' do
                '34501'
            end
            td :style => 'border:1px solid black;' do
                "Search for ' FeaturedReviews.RestaurantID ' in page source and get integer"
            end
        end
        tr do
            td :style => 'border:1px solid black;' do
                'Google'
            end
            td :style => 'border:1px solid black;' do
                "N/A"
            end
            td :style => 'border:1px solid black; ' do
                'CqQBlQAAAIpI_j7Mt6PkTMnJ6SqsgoQ3wsVReoM8jSwJapt56TEfej1TG1sk0dSUxGsoljqHJB6NAmUOQ3GqLjZ53mwBFdvkYKMTkpbDaOz8SwOhFReia2r6hO_Rkvq02CCbinZM2COchOJI6OreV8bssKtrzsHAr4lMMHyiJLJvceG7R6OklLN4rWoyAMaazVnORTUQw10J_GprzyMLPoCAFCooXoUSEGVQge5CeRw1b53cP6M1vP8aFBam2IAUeVmC7nkV1LTT0CH5xCYQ'
            end
            td :style => 'border:1px solid black;' do
                "We need the reference ID that comes back on a Places API request Search. You'll need the location's lat, long, and search term (usually the locations name and needs to be URI encoded). Good site for lat/long points based on address: itouchmap.com/latlong.html  
                The call can be done from your browser in the format (https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=[lat],[long]&keyword=[locationname]&radius=500&sensor=false&key=AIzaSyAfzgIC3a-sxgoaFMZ7nZn9ioSZfwMenhM) 
                Example call for Zinc Wine & Bar: https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=29.426895,-98.492872&keyword=luke&radius=500&sensor=false&key=AIzaSyAfzgIC3a-sxgoaFMZ7nZn9ioSZfwMenhM"
            end
        end
        tr do
            td :style => 'border:1px solid black;' do
                'UrbanSpoon'
            end
            td :style => 'border:1px solid black;' do
                "http://www.urbanspoon.com/r/39/432569/restaurant/Riverwalk/Zinc-Bistro-Wine-Bar-San-Antonio"
            end
            td :style => 'border:1px solid black;' do
                'r/39/432569/restaurant/Riverwalk/Zinc-Bistro-Wine-Bar-San-Antonio'
            end
            td :style => 'border:1px solid black;' do
                ''
            end
        end
        tr do
            td :style => 'border:1px solid black;' do
                'Yelp'
            end
            td :style => 'border:1px solid black;' do
                "http://www.yelp.com/biz/zinc-bistro-and-wine-bar-san-antonio"
            end
            td :style => 'border:1px solid black;' do
                'zinc-bistro-and-wine-bar-san-antonio'
            end
            td :style => 'border:1px solid black;' do
                ''
            end
        end
        tr do
            td :style => 'border:1px solid black;' do
                'TripAdvisor'
            end
            td :style => 'border:1px solid black;' do
                "http://www.tripadvisor.com/Restaurant_Review-g60956-d437288-Reviews-Zinc_Champagne_Wine_Bar-San_Antonio_Texas.html"
            end
            td :style => 'border:1px solid black;' do
                'Restaurant_Review-g60956-d437288-Reviews-Zinc_Champagne_Wine_Bar-San_Antonio_Texas.html'
            end
            td :style => 'border:1px solid black;' do
                ''
            end
        end

    end

    
  end # content
end
