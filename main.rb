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

    print "titles array length: "
    puts titles.length

    ratings = []
    html_doc.css('dl.rating').each do | dl_tag |
        # dl_tag.children.each do | children |
        #     puts children
        # end
        dl_tag.css('dd').each do | rating |
            ratings.append(rating.text)
        end

    end

    print "ratings array length: "
    puts ratings.length
    puts ""

    titles.shift(6) # 6 is the number of the first 5 topics in the Introduction
    titles.pop(4)

    puts "titles array new length: #{titles.length}"
    puts titles[0..10]
    puts ""

    ratings.shift(9) # 9 is the number of the first 8 explanations of the Impact and Effort part
    puts "ratings array new length: #{ratings.length}"
    puts ratings[0..10]

    puts ""

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
            # puts key
            # puts [value["Impact"], value["Effort"]]
            csv << [String(key), value["Impact"], value["Effort"]]
            #csv << [elem["Impact"], elem["Effort"]]
        }
    }
else 
    puts "Failed: #{response.code}"
end