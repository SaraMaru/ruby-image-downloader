require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open("http://www.jianshu.com/p/fab4e426682c"))
imgs = doc.xpath('//img')
index = 1
imgs.each do |im|
	p im
	srcline = im.to_s
	p srcline
	src = srcline.scan(%r{src="(.*)" })[0][0] #url可能以"//"，或"http://"，或"https://"开头
	if src[0]!= 'h'
		src = "http:" + src
	end
	p src
	imgfile = open(src,"rb") { |f| f.read }
	open(index.to_s+".png","wb") { |f| f.write(imgfile)}
	index += 1;
end