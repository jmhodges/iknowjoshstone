xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "I Know Josh Stone"
  xml.link    "rel" => "self", "href" => 'http://iknowjoshstone.com/feed'
  xml.link    "rel" => "alternate", "href" => 'http://iknowjoshstone.com/'
  xml.id      'http://iknowjoshstone.com/'
  xml.updated @posts.first[:created_at].strftime "%Y-%m-%dT%H:%M:%SZ" if !@posts.empty?
  xml.author  { xml.name "Everyone who knows Josh Stone" }

  @posts.each do |post|
    xml.entry do
      xml.title   "#{post[:whotheyare]} knows Josh Stone"
      xml.link    "rel" => "alternate", "href" => "http://iknowjoshstone.com/post/#{post.id}"
      xml.id      "http://iknowjoshstone.com/post/#{post.id}"
      xml.updated post[:created_at].strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name post[:whotheyare] }
      xml.content "type" => "html" do
        xml.text! post[:howtheyknowhim]
      end
    end
  end

end
