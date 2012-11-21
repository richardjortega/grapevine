require 'rubygems'
require 'ap'
require 'debugger'

reviews_most_helpful = [{
            :review => " Great place to grab a few drinks an appetizers before a concert. We sat on the patio and enjoyed the start of our evening. The server disappeared for a while and we had to look for her to get another round and our check. We'll be back!",
            :author => "Roy Simmons",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Good"
    },
     {
            :review => " Having lunch right now. What a find. Not your typical touristy place. Great wine and superb food. Very reasonably priced. Very friendly staff. 10 in our book.",
            :author => "Linda Kennedy",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " Away from the hussle of river walk, you get some of the best drinks, and food if you want to spend your evening somewhere romantic. We had the pasta portofino and zinc and caesar salad. Meat was cooked right and the salad was very fresh.",
            :author => "Ashkan Yazdi",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " This was a real find! We are in San Antonio for a conference and found this place on line. Fantastic wine list, great limited menu and amazing prices! For all the overpriced and bad Mexican food on the Riverwalk, this is a gem. Recommendations: the Zinc Salad ($3 at this writing), any pizza and Oregon/Washington wines on the list. Loved it so much, we went the next night.",
            :author => "Steve Smith",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " I really enjoy coming to this place often. It is rare to find stylish, classy bars/restaurants in downtown San Antonio, but this one is worth visiting. It is within walking distance from the Riverwalk, but a little tucked away to remain relatively private and local-friendly. I haven't sampled everything on the menu, but I really like sharing their cheese plate (or antipasto plate) with friends over wine. The Zinc Burger, the Portabello Patty Melt, and the Truffled Parmesan Fries are DELICIOUS. Their desserts are fantastic-- Cinnamon Sopapillas, Chocolate-covered Strawberries, Brioche Apple Bread Pudding Souffle, and Vanilla Bean Creme Brulee. Wear your eating pants. They have a HUGE bar menu, with a variety of wine, champagne, and liquor. The beer list is not as extensive. Their Prickly Pear Margarita is popular, but I really like their Ruby Red (Grapefruit-esque Martini) and the Orange Blossom Martini. Cigars are available as well.",
            :author => "Bryn Harrington",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Very good"
    },
     {
            :review => " A nice surprise among the tourist-class restaurants that are all over downtown San Antonio. A nice reasonably priced wine selection with wines that aren't \"everywhere\"--a good selection from Spain, South America, France, and the expected California. The help was attentive and friendly, and the \"Portobello Patty Melt\" I had was a delight! The Portobello mushroom was atop a very nice bed of sauteed spinach with garlic and onion and topped with some petite asparagus. An unexpected healthy snack. A nice place without too much pretension, and my only obvious improvement would be the addition of a real zinc-topped bar. A great surprise amidst the faux-historical, faux-famous stuff that surrounds Zinc.",
            :author => "Curt Reynolds",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    }]

reviews_latest = [{
            :review => " Great place to grab a few drinks an appetizers before a concert. We sat on the patio and enjoyed the start of our evening. The server disappeared for a while and we had to look for her to get another round and our check. We'll be back!",
            :author => "Roy Simmons",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Good"
    },
     {
            :review => " Awesome Food",
            :author => "Manuel Elizondo",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " Having lunch right now. What a find. Not your typical touristy place. Great wine and superb food. Very reasonably priced. Very friendly staff. 10 in our book.",
            :author => "Linda Kennedy",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " I really enjoy coming to this place often. It is rare to find stylish, classy bars/restaurants in downtown San Antonio, but this one is worth visiting. It is within walking distance from the Riverwalk, but a little tucked away to remain relatively private and local-friendly. I haven't sampled everything on the menu, but I really like sharing their cheese plate (or antipasto plate) with friends over wine. The Zinc Burger, the Portabello Patty Melt, and the Truffled Parmesan Fries are DELICIOUS. Their desserts are fantastic-- Cinnamon Sopapillas, Chocolate-covered Strawberries, Brioche Apple Bread Pudding Souffle, and Vanilla Bean Creme Brulee. Wear your eating pants. They have a HUGE bar menu, with a variety of wine, champagne, and liquor. The beer list is not as extensive. Their Prickly Pear Margarita is popular, but I really like their Ruby Red (Grapefruit-esque Martini) and the Orange Blossom Martini. Cigars are available as well.",
            :author => "Bryn Harrington",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Very good"
    },
     {
            :review => " This was a real find! We are in San Antonio for a conference and found this place on line. Fantastic wine list, great limited menu and amazing prices! For all the overpriced and bad Mexican food on the Riverwalk, this is a gem. Recommendations: the Zinc Salad ($3 at this writing), any pizza and Oregon/Washington wines on the list. Loved it so much, we went the next night.",
            :author => "Steve Smith",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " Away from the hussle of river walk, you get some of the best drinks, and food if you want to spend your evening somewhere romantic. We had the pasta portofino and zinc and caesar salad. Meat was cooked right and the salad was very fresh.",
            :author => "Ashkan Yazdi",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " A nice surprise among the tourist-class restaurants that are all over downtown San Antonio. A nice reasonably priced wine selection with wines that aren't \"everywhere\"--a good selection from Spain, South America, France, and the expected California. The help was attentive and friendly, and the \"Portobello Patty Melt\" I had was a delight! The Portobello mushroom was atop a very nice bed of sauteed spinach with garlic and onion and topped with some petite asparagus. An unexpected healthy snack. A nice place without too much pretension, and my only obvious improvement would be the addition of a real zinc-topped bar. A great surprise amidst the faux-historical, faux-famous stuff that surrounds Zinc.",
            :author => "Curt Reynolds",
             :decor => "Excellent",
        :atmosphere => "Excellent",
           :service => "Excellent"
    },
     {
            :review => " I would have to say that the atmosphere was very nice and they had a wonderful wine selection, with that said our group was taken here from Bodros to wait on a table to come open to eat or at least that is what we were told. When we arrived at Zinc's they tried to set us as if we were eating dinner there, one of the gentleman in our group explained to them that we were not eating there that we were just going to have a couple of cocktails until our table came open at Bodro's. This did not make the employees very happy at all and it reflected in the service we received, they were extremely rude from that point on and acted as if they did not want us there. I had one drink, which was a Mojito and it was excellent which is saying a lot because a good Majito is hard to come by. We did not eat so I can not speak for the food. I would say that maybe we should go back and give them another chance under different conditions I feel for sure that the service would be much better, but until then I can only give them 3 stars.",
            :author => "A Google User",
           :overall => "Good"
    },
     {
            :review => " I was in search of food and drink. Happenned upon this via my phone searching for restaurants open after 10. Reviews looked good and certainly didn't disappoint. Though I ate solo, it was still good...I will save this as a fav. San Antonio is know for it's mexican food, but this is a hidden jewel in the heart of SA.",
            :author => "A Google User",
           :overall => "Excellent"
    },
     {
            :review => " Love whoever takes you there because they have good taste. It has a great atmosphere, terrific menu and wonderful wine selection fit for gourmets and sophisticated souls.",
            :author => "Maes Re",
           :overall => "Excellent"
    }]