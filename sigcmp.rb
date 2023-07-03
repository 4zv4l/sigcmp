#!/bin/ruby

require 'nokogiri'
require 'httparty'

def scrap_steam(game, verbose)
  puts "== STEAM =="
  search_url = 'https://store.steampowered.com/search/?term='
  resp = HTTParty.get "#{search_url}#{game}"
  doc = Nokogiri::HTML resp.body
  doc.css('a[class="search_result_row ds_collapse_flag "]').each do |e|
    link = e['href']
    title = e.at_css('span[class="title"]').text
    price = e.to_s.match(/([\d,]+€)|(Free)/)
    puts verbose ? "(#{price}) #{title} => #{link}" : "(#{price}) #{title}"
  end
end

def scrap_instant_gaming(game, verbose)
  puts "== INSTANT GAMING =="
  search_url = 'https://www.instant-gaming.com/en/search/?query='
  resp = HTTParty.get "#{search_url}#{game}"
  doc = Nokogiri::HTML resp.body
  doc.css('a[class="cover "]').each do |e|
    link = e['href']
    title = e.at_css('img')['alt']
    price = e['title'].split.last
    puts verbose ? "(#{price}) #{title} => #{link}" : "(#{price}) #{title}"
  end
end

game = ARGV[0] || (print "game> "; $stdin.gets)
verbose = ARGV.any?(["-v", "--verbose"])
scrap_steam(game, verbose)
scrap_instant_gaming(game, verbose)
