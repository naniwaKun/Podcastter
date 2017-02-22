class Update
  require_relative "./tm.rb"
  require_relative "./rss.rb"
  require_relative "./image.rb"
  require_relative "./post.rb"
  require 'json'

  def makeWeb(settei)

    main = Twimane.new
    items = main.get_tweet(settei)

    image = ImageCreate.new
    image.getImage(settei["baseDir"] + settei["fontPath"],settei["imageTitle"],settei["baseDir"] + settei["imageDir"],"image.png")

    rssObj = Podrss.new
    rss = rssObj.makeRss(items,settei)
    File.open(settei["baseDir"] + "public/rss.xml", "w") do |f|
      f.puts(rss)
    end

    post = Post.new
    post.createIndex(settei)
    post.createPost(settei)

  end
end
