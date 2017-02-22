class Post
  require 'rss'
  require 'slim'
  require 'slim/include'
  require 'json'

  def createPost(hash)
    rss = RSS::Parser.parse(hash["baseDir"] + 'public/rss.xml')
    rss.items.each{|i|
      @description = i.description
      @title = i.title
      @settei = hash
      html = Slim::Template.new(@settei["baseDir"] + "views/post.slim").render(self)
      File.open( @settei["baseDir"] + "public/post/" + i.title + ".html", "w") do |f| 
        f.puts(html)
      end
    }
  end

  def createIndex(hash)
    rss = RSS::Parser.parse(hash["baseDir"] + 'public/rss.xml')

    @items = rss.items
    @settei = hash

    html = Slim::Template.new(@settei["baseDir"] + "views/index.slim").render(self)

    File.open(@settei["baseDir"] + "public/post/index.html", "w") do |f| 
      f.puts(html)
    end
  end
end
