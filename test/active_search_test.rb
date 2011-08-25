require 'test_helper'

class ActiveSearchTest < Test::Unit::TestCase
  
  def setup
    ActiveSearch.options[:api_key] = API_KEY
    @from_date = Date.new(2011,8,1)
    @to_date = Date.new(2011,9,1)
    @media_type = 'Event'
  end
  
  
  def test_can_search_with_keywords
    results = ActiveSearch.find('running')
    assert results.any?
  end
  
  
  def test_can_search_without_keywords
    results = ActiveSearch.find
    assert results.any?
  end
  
  
  def test_can_search_with_type
    results = ActiveSearch.find :type => 'articles'
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
  
  
  def test_can_search_with_sort
    relevance_sort = ActiveSearch.find
    date_asc_sort = ActiveSearch.find :sort => 'date_asc'
    date_desc_sort = ActiveSearch.find :sort => 'date_desc'
    
    assert_not_equal relevance_sort, date_asc_sort
    assert_not_equal date_asc_sort, date_desc_sort
    
    #asc_dates = date_asc_sort.collect(&:start_date)
    #assert_equal asc_dates, asc_dates.sort
  end
  
  
  def test_can_search_with_date_range
    results = ActiveSearch.find :date_range => @from_date..@to_date
    assert (results.first.start_date >= @from_date and results.first.start_date <= @to_date)
  end
  
  
  def test_can_search_with_media_type
    results = ActiveSearch.find :media_type => @media_type
    assert results.any?
  end
  
  
  def test_can_search_with_multiple_meta_values
    results = ActiveSearch.find :date_range => @from_date..@to_date, :media_type => @media_type
    assert results.any?
  end
  
  
  def test_can_search_with_location
    results = ActiveSearch.find :location => 'San Diego, CA, US'
    assert_equal 'San Diego', results.first.city
  end
  
  
  def test_can_search_with_media_type
    results = ActiveSearch.find :media_type => 'Class'
    assert results.first.media_types.include? 'Class'
  end
  
  
  def test_can_search_with_channel
    results = ActiveSearch.find :channel => 'Running'
    assert results.first.channels.include? 'Running'
    
    results = ActiveSearch.find 'swim', :channel => 'Running'
    assert results.first.channels.include? 'Running'
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
  
  
  def test_result_with_image_returns_image
    results = ActiveSearch.find :type => 'articles'
    result_with_image = results.find { |r| r.image }
    assert result_with_image
  end
  
  
  def test_result_with_byline_returns_byline
    results = ActiveSearch.find :type => 'articles'
    result_with_byline = results.find { |r| r.byline }
    assert result_with_byline
  end
  
  
  def test_result_without_image_returns_nil
    results = ActiveSearch.find
    result_with_image = results.find { |r| r.image }
    assert_nil result_with_image
  end
  
  
  def test_result_without_byline_returns_nil
    results = ActiveSearch.find
    result_with_byline = results.find { |r| r.byline }
    assert_nil result_with_byline
  end
  
end