require 'httparty'
require 'nokogiri'
require 'csv'

url = "https://w3c.github.io/sustyweb"
response = HTTParty.get(url)


if response.code == 200
    puts "Success!"
    html_doc = Nokogiri::HTML(response.body) #{ |conf| conf.noblanks }
    
    titles = []
    html_doc.css('h3').each do | title |
        titles.append(title.text)
    end

    ratings = []
    html_doc.css('dl.rating').each do | dl_tag |
        dl_tag.css('dd').each do | rating |
            ratings.append(rating.text)
        end

    end

    stuff = {}
    titles.each_with_index do | key, index |
        start_index = index * 2

        impact_value = ratings[start_index]
        effort_value = ratings[start_index + 1]

        sub_hash = {"Impact" => impact_value, "Effort" => effort_value}
        stuff[key] = sub_hash
    end

    CSV.open("data.csv", "wb") { |csv| 
        csv << ['Title', 'Impact', 'Effort']
        stuff.each { |key, value| 
            csv << [String(key), value["Impact"], value["Effort"]]
        }
    }
else 
    puts "Failed: #{response.code}"
end