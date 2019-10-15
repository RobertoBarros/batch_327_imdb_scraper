require 'yaml'
require_relative 'scraper'

top_urls = fetch_top_movie_urls

movies = []
puts "scraping movies..."
top_urls.each do |url|
  movies << scrape_movie(url)
end

File.open('movies.yml', 'wb') do |file|
  file.write(movies.to_yaml)
end

