require 'httparty'
require 'nokogiri'
require 'json'
require 'csv'

url = "https://w3c.github.io/sustyweb"
response = HTTParty.get(url)
save_to_json = true

# Handle input argument for saving to -csv
if !ARGV.empty? and ARGV[0].downcase == "-csv"
    save_to_json = false
end

if response.code == 200
    puts "Success!"
    
    # Constants
    Id = "Id"
    Title = "Title" 
    Impact = "Impact" 
    Effort = "Effort" 
    Filename = "wsg-titles-impacts-efforts"

    # Allocation of variables
    wsg_info = []
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

        id_value, title_value = key.split(/ /, 2)
        impact_value = ratings[start_index]
        effort_value = ratings[start_index + 1]

        sub_hash = {Id => id_value, Title => title_value, Impact => impact_value, Effort => effort_value}
        wsg_info.append(sub_hash)
    end

    if save_to_json 
        # Export to .json
        File.open(Filename+".json", "wb") { |json|
            json.write(JSON.pretty_generate(wsg_info))
        }
    else
        # Build the .csv-file for Title, Impact and Effort as columns
        CSV.open(Filename+".csv", "wb") { |csv| 
            csv << [Id, Title, Impact, Effort]
            wsg_info.each { |obj| 
                csv << [obj[Id], obj[Title], obj[Impact], obj[Effort]]
            }
        }
    end
else 
    puts "Failed: #{response.code}"
end