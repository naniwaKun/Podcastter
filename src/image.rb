class ImageCreate
require "rmagick"
include Magick

def getImageEp(fontPath,str,path,name,str2)
  color = ["#FBEFF5","#F8EFFB","#F2EFFB","#EFF5FB","#EFFBF8","#EFFBEF","#F8FBEF","#FBF8EF","#FBEFEF"]
  color.shuffle!
  image = Magick::Image.new(550, 300) { self.background_color = color.shift }
	draw = Magick::Draw.new
	draw.font = fontPath
	draw.pointsize = 35
	draw.gravity = CenterGravity
	str = str.gsub(/(_)/,"\n").encode("UTF-8")
	draw.annotate(image, 0, 0, 0, -80, str)
	draw.pointsize = 25
  str2 = str2.scan(/.{1,14}/).join("\n")
	draw.annotate(image, 0, 0, 0, 50, str2)
	image.write( path + '/' + name )
	return path + '/' + name
end
def getImage(fontPath,str,path,name)

	image = Magick::Image.new(1400, 1400) { self.background_color = "#fffafa" }
	draw = Magick::Draw.new
	draw.font = fontPath
	draw.pointsize = 300
	draw.gravity = CenterGravity
	draw.annotate(image, 0, 0, 0, 0, str.encode("UTF-8"))
	image.write( path + '/' + name )
	return path + '/' + name

end
end
