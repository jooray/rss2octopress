require 'rss'
require 'babosa'

# change these
inputFile = 'soup_export.rss'
outputDir = '/home/octopress/octopress/source/_posts'
# 

rss_source = File.read(inputFile)
rss = RSS::Parser.parse(rss_source, true)

rss.items.each do |i|
	# I decided to skip links to third party sites and videos, feel free to modify
	# your own conditions
	if i.source.nil? and i.categories[0].content!="video"
		puts i.title
		markdown = ""
		IO.popen("perl html2markdown.pl", "r+") do |p|
			p.write i.description
			p.close_write
			markdown = p.read
		end
		date="#{i.pubDate.year}-#{i.pubDate.month < 10 ? "0" : ""}#{i.pubDate.month}-#{i.pubDate.day < 10 ? "0" : ""}#{i.pubDate.day}"
		f=File.new("#{outputDir}/#{date}-#{i.title.to_slug.normalize}.markdown","w")
		title=i.title.gsub(/"/,"\\\"")
		f.puts "---
layout: post
title: \"#{title}\"
date: #{date} #{i.pubDate.hour}:#{i.pubDate.min}
comments: true
external-url:
categories:
---
"
		f.write markdown
		f.close
	end
end

