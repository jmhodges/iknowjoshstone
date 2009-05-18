require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestIknowjoshstone < Test::Unit::TestCase
  def app
    Iknowjoshstone
  end
  
  def setup
    Iknowjoshstone::DB[:posts].delete
    Iknowjoshstone::DB[:posts] << {:whotheyare => "melanie", :howtheyknowhim => "in short, from being fantastic", :created_at => Time.now}
    Iknowjoshstone::DB[:posts] << {:whotheyare => "jeff", :howtheyknowhim => "from passa passa reggae, via melanie", :created_at => Time.now}
  end

  def teardown
    Iknowjoshstone::DB[:posts].delete
  end
  
  def test_has_an_index_with_post_divs
    visit '/'
    assert_equal 200, response_code, "index should respond with a 2xx"
    assert_not_equal [], (parsed / 'div.post').to_a
  end

  def test_index_displays_awesome_posts
    visit '/'
    posts = parsed / 'div.post'
    assert_equal "melanie", posts[0].at('.whotheyare').content.strip
    assert_equal "jeff", posts[1].at('.whotheyare').content.strip
    assert_equal "in short, from being fantastic", posts[0].at('div.howtheyknowhim').content.strip
    assert_equal "from passa passa reggae, via melanie", posts[1].at('div.howtheyknowhim').content.strip
  end

  def test_index_links_to_a_form_for_adding_a_post
    visit '/'
    assert_not_nil parsed.at('a[@href="/posts/new"]')
  end

  def test_has_a_nice_form_page_for_adding_posts
    visit '/posts/new'
    assert response.ok?, "new post page should respond with a 2xx like a boss"
    form = parsed.at('form[@action="/posts/create"][@id="new_post"]')
    assert_not_nil form
    assert_not_nil form.at('input[@name="post[whotheyare]"][@id="whotheyare"][@type="text"]')
    assert_not_nil form.at('label[@for="whotheyare"]')
    assert_not_nil form.at('textarea[@name="post[howtheyknowhim]"][@id="howtheyknowhim"]')
    assert_not_nil form.at('label[@for="howtheyknowhim"]')
    assert_not_nil form.at('button[@type="submit"]')
  end

  def test_index_to_new_post
    assert_equal [], Iknowjoshstone::DB[:posts].filter(:whotheyare => "megan").all
    
    visit '/'
    click_link 'Do you know Josh Stone?'
    fill_in 'whotheyare', :with => "megan"
    fill_in 'howtheyknowhim', :with => 'not sure but i remember beats and mel'
    submit_form 'new_post'
    assert response.ok?, "posted just fine"
    posts = Iknowjoshstone::DB[:posts].filter(:whotheyare => "megan").all
    assert_equal 1, posts.size

    post = posts[0]
    assert_equal "megan", post[:whotheyare] # Obvious from the filter
    assert_equal 'not sure but i remember beats and mel', post[:howtheyknowhim]
    assert_in_delta Time.now, post[:created_at], 30
    
    # assert_have_selector 'div.saved'
    # assert_equal "You really know Josh, hunh, megan?", parsed.at('div.saved').content.strip
  end
  
  private
  def parsed
    Nokogiri::HTML.parse(response_body)
  end
end
