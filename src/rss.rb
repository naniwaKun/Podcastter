class Podrss
  require_relative "./mp3tag.rb"
  require_relative "./image.rb"
  require 'builder/xmlmarkup'

  def makeRss(items , settei)
    ret = ""
    xml = Builder::XmlMarkup.new(:target=>ret ,:indent => 2)
    xml.instruct!

    xml.rss("version" => "2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd","xmlns:atom"=>"http://www.w3.org/2005/Atom") do

      xml.channel do
        xml.title settei["title"]
        xml.tag!("atom:link", "href"=>settei["feedUrl"],"rel"=>"self", "type"=>"application/rss+xml" )
        xml.link settei["twitterUrl"]
        xml.description settei["description"]
        xml.category settei["category"]
        xml.pubDate Time.now.rfc822
        xml.lastBuildDate Time.now.rfc822
        xml.language settei["lang"]
        xml.copyright settei["copylight"]
        xml.generator "PodcastCreaterByTwitter - https://github.com/naniwaKun/PodcastCreaterByTwitter"
        xml.managingEditor settei["mail"]
        xml.webMaster settei["webmaster"]
        xml.image do
          xml.title settei["title"]
          xml.url(settei["baseUrl"]+settei["imageDir"]+"image.png")
          xml.link settei["twitterUrl"]
        end
        xml.ttl "60"
        xml.tag!("itunes:author",settei["author"])
        xml.tag!("itunes:explicit",settei["explicit"])
        xml.tag!("itunes:image","href"=>settei["baseUrl"]+settei["imageDir"]+"image.png")
        xml.tag!("itunes:subtitle",settei["description"])
        xml.tag!("itunes:category", "text"=>settei["category"])
        xml.tag!("itunes:summary", settei["description"])
        xml.tag!("itunes:owner") do
          xml.tag!("itunes:name", settei["title"])
          xml.tag!("itunes:email", settei["mail"])
        end
        items.each{|i|
          xml.item do
            title = URI.unescape(i[1]).split("/").pop.split(".").shift
            xml.title title
            xml.link i[0]
            xml.pubDate Time.parse(i[2].to_s).rfc822
            mp3Url = settei["baseUrl"]+settei["mp3Dir"]+URI.escape(title)+".mp3"
            xml.tag!("guid", i[0])
            xml.description i[3].to_s
            xml.tag!("itunes:subtitle", i[3])
            xml.tag!("itunes:summary", i[3])
            xml.tag!("itunes:author", settei["author"])
            timeObj = Mp3tag.new
            time =  timeObj.getTag(settei["baseDir"]+settei["mp3Dir"]+title+".mp3")
            xml.enclosure("url"=> mp3Url , "length" => File.size(settei["baseDir"]+settei["mp3Dir"]+title+".mp3")  , "type" => "audio/mpeg")
            xml.tag!("itunes:explicit", settei["explicit"])
            xml.tag!("itunes:duration", time)

            image = ImageCreate.new
            image.getImageEp(settei["baseDir"] + settei["fontPath"],title,settei["baseDir"] + settei["imageDir"],title+".png",i[3])
            timeObj.addImage(settei["baseDir"]+settei["mp3Dir"]+title+".mp3",settei["baseDir"] + settei["imageDir"] + title+".png")
          end
        }
      end
    end
    return ret
  end
end
