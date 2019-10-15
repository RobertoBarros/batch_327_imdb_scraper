require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)
  urls = []
  html_doc.search(".titleColumn a").first(5).each do |url|
    urls << "https://www.imdb.com#{url.attribute("href").value}"
  end
  urls
end

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  title_year = html_doc.search("h1").text.strip
  pattern = /^(?<title>.*)\((?<year>\d{4})\)$/

  title = title_year.match(pattern)[:title].chop
  year = title_year.match(pattern)[:year].to_i

  {
    title: title,
    year: year,
    storyline: html_doc.search('.summary_text').text.strip,
    director: html_doc.search('.credit_summary_item a').first.text.strip,
    cast: html_doc.search('.credit_summary_item').last.search('a').first(3).map(&:text)
  }
end

