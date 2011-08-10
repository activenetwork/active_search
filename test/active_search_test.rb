require 'test_helper'

class ActiveSearchTest < Test::Unit::TestCase
  
  def setup
    ActiveSearch.options[:api_key] = API_KEY
  end
  
  def test_can_search_with_keywords
    results = ActiveSearch.find('running')
    assert results.any?
  end
  
  def test_can_search_without_keywords
    results = ActiveSearch.find
    assert results.any?
  end
  
  def test_can_search_with_pages
    first_page = ActiveSearch.find
    second_page = ActiveSearch.find :page => 2
    assert_not_equal first_page, second_page
  end
  
  def test_can_search_with_num
    results = ActiveSearch.find :num => 5
    assert_equal 5, results.length
  end
  
  def test_can_search_with_location
    results = ActiveSearch.find :location => 'San Diego, CA, US'
    assert_equal 'San Diego', results.first.city
  end
  
  def test_error_hidden_without_bang_find
    assert_nothing_raised ActiveSearch::SearchError do
      ActiveSearch.find :location => 'San Diego, CA'
    end
  end
  
  def test_raise_exception_with_bang_find_and_invalid_location
    assert_raises ActiveSearch::SearchError do
      ActiveSearch.find! :location => 'San Diego, CA'
    end
  end
  
  
  
end