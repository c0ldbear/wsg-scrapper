require 'httparty'
require 'nokogiri'

url = "https://w3c.github.io/sustyweb"
response = HTTParty.get(url)

stuff = {}

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
else 
    puts "Failed: #{response.code}"
end