require 'mechanize'
require 'pry-byebug'
require 'csv'

scraper = Mechanize.new

scraper.history_added = Proc.new { sleep 0.5 }
ADDRESS = 'https://newyork.craigslist.org/search/mnh/apa?min_bedrooms=3&max_bedrooms=3&min_bathrooms=2&max_bathrooms=2&availabilityMode=0&sale_date=all+dates'
results = []
results << ['Title', 'Address', 'Rent','URL']

scraper.get(ADDRESS) do |search_page|
    raw_results = search_page.search('div.result-info')
    array = []
    raw_results.each do |result|
        link = result.search('a')[0]
        title = link.text.strip
        address = result.search('span.result-hood').text
        rent = result.search('span.result-price').text
        url = "http://sfbay.craigslist.org" + link.attributes["href"].value
        results << [title, address, rent, url]
    end
end

CSV.open("craiglist-3b-2b.csv", "w+") do |csv_file|
    results.each do |row|
      csv_file << row
    end
  end

