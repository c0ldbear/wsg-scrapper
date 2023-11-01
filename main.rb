require 'httparty'
require 'nokogiri'
require 'csv'

url = "https://w3c.github.io/sustyweb"
response = HTTParty.get(url)

if response.code == 200
    puts "Success!"
    
    # Constants
    Title = "Title" 
    Impact = "Impact" 
    Effort = "Effort" 
    Filename = "wsg-titles-impacts-efforts.csv"

    # Allocation of variables
    wsg_info = {}
    html_doc = Nokogiri::HTML(response.body) 
    
    # Parse titles
    titles = []
    html_doc.css('h3').each do | title |
        titles.append(title.text)
    end

    # Clean titles
    titles.shift(6) # 6 is the number of the first 6 topics, the Introduction
    titles.pop(4)   # 4 is the number of the last 4 topics, the Appendix

    # Parse ratings (Impact and Effort)
    ratings = []
    html_doc.css('dl.rating').each do | dl_tag |
        dl_tag.css('dd').each do | rating |
            ratings.append(rating.text)
        end
    end

    # Clean ratings
    ratings.shift(9) # 9 is the number of the first 9 explanations of the Impact and Effort part

    # Create the Hash that contains the Title and corresponding Rating (Impact and Effort)
    titles.each_with_index do | key, index |
        start_index = index * 2

        impact_value = ratings[start_index]
        effort_value = ratings[start_index + 1]

        sub_hash = {Impact => impact_value, Effort => effort_value}
        wsg_info[key] = sub_hash
    end

    # Build the .csv-file for Title, Impact and Effort as columns
    CSV.open(Filename, "wb") { |csv| 
        csv << [Title, Impact, Effort]
        wsg_info.each { |key, value| 
            csv << [key, value[Impact], value[Effort]]
        }
    }
else 
    puts "Failed: #{response.code}"
end