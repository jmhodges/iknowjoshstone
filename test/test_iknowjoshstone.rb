require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestIknowjoshstone < Test::Unit::TestCase
  include Sinatra::Test
  def setup
    @app = Iknowjoshstone
    Iknowjoshstone::DB[:posts].delete
    Iknowjoshstone::DB[:posts] << {:whotheyare => "melanie", :howtheyknowhim => "in short, from being fantastic", :created_at => Time.now}
    Iknowjoshstone::DB[:posts] << {:whotheyare => "jeff", :howtheyknowhim => "from passa passa reggae, via melanie", :created_at => Time.now}
  end

  def teardown
    Iknowjoshstone::DB[:posts].delete
  end
  
  def test_has_an_index_with_post_divs
    get '/'
    assert response.ok?, "index should respond with a 2xx"
    assert_not_equal [], (parsed / 'div.post').to_a
  end

  def test_index_displays_awesome_posts
    get '/'
    posts = parsed / 'div.post'
    assert_equal "melanie", posts[0].at('div.whotheyare').content.strip
    assert_equal "jeff", posts[1].at('div.whotheyare').content.strip
    assert_equal "in short, from being fantastic", posts[0].at('div.howtheyknowhim').content.strip
    assert_equal "from passa passa reggae, via melanie", posts[1].at('div.howtheyknowhim').content.strip
  end

  def test_index_links_to_a_form_for_adding_a_post
    get '/'
    assert_not_nil parsed.at('a[@href="/posts/new"]')
  end

  def test_has_a_nice_form_page_for_adding_posts
    get '/posts/new'
    assert response.ok?, "new post page should respond with a 2xx like a boss"
    form = parsed.at('form[@action="/posts/create"]')
    assert_not_nil form
    assert_not_nil form.at('input[@name="whotheyare"][@id="whotheyare_text"]')
    assert_not_nil form.at('label[@for="whotheyare_text"]')
    assert_not_nil form.at('textarea[@name="howtheyknowhim"][@id="howtheyknowhim_text"]')
    assert_not_nil form.at('label[@for="howtheyknowhim_text"]')
    assert_not_nil form.at('button[@type="submit"]')
  end
  
  private
  def parsed
    Nokogiri::HTML.parse(response.body)
  end
end
