require 'nokogiri'
require 'open-uri'

web_url = 'http://www.iplaysoft.com/' #请输入完整的web_url
out_path = 'C:\Users\lenovo\Desktop' #out_path最后的/可以省略(因为下一句代码会自动补全地址)

out_path += "/" if out_path[-1]!="/" && out_path[-1]!="\\"
doc = Nokogiri::HTML(open(web_url))
doc.css("img").each_with_index do |item_img,index|
    img_url = item_img[:src]

    if img_url[0]!="h" #如果url不是以http或者https开头
	    if img_url[0..1]=="//" #绝对路径
	    	img_url = "http:" + img_url
	    elsif img_url[0]=="/" #从根目录出发的相对路径
	    	root = web_url.split("/")[2] #注意到前面有个http://或https://
	    	img_url = web_url.split("/")[0] + "//" + root + img_url
	    else #同一个文件夹中的引用，或者是使用../的引用
	    	times = img_url.scan(%r{\.\./}).length
			short_img_url = img_url.gsub(%r{\.\./},"")
			pieces = web_url.split("/")
			part_num = pieces.length - 2 #网站的url在//后面有part_num个部分
			short_web_url = pieces[0] + "//"
			for i in 1..(part_num-times-1) #还有partnum-times-1个部分剩余（对于以/结尾的web_url是否正确？）
				short_web_url = short_web_url + pieces[i+1] + "/"
			end
			absolute_url = short_web_url + short_img_url
		end
	end

    puts img_url
    format = img_url.split(".")[-1]
    if format!="jpg" && format!="jpeg" && format!="bmp" && format!="gif" #不一定有后缀名
    	format = "png"
    end
    img_file = open(img_url,"rb") { |f| f.read }
	open(out_path+(index+1).to_s+"."+format,"wb") { |f| f.write(img_file)}
end