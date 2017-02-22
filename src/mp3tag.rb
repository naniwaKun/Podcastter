class Mp3tag
require 'mp3info'

def getTag(mp3Path)
  Mp3Info.open(mp3Path) do |mp3|
    Time.at(mp3.length).utc.strftime('%X')
  end
end
def addImage(mp3Path,imagePath)
file = File.new(imagePath,'rb')
  Mp3Info.open(mp3Path) do |mp3|
    mp3.tag2.add_picture(file.read)
  end
end
end
