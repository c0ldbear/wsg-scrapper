require 'httparty'
require 'nokogiri'

url = "https://w3c.github.io/sustyweb"
response = HTTParty.get(url)

if response.code == 200
    puts "Success!"
    html_doc = Nokogiri::HTML(response.body)
    
    titles = []
    html_doc.css('h3').each do | paragraph |
        titles.append(paragraph.text)
    end

    puts titles

    html_doc.css('h4').each do | paragraph |
        if paragraph.text.downcase.eql? "impact & effort"
            puts paragraph.text
        end
    end

else 
    puts "Failed: #{response.code}"
end
