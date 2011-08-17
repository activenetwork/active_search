require 'test_helper'

class FinderTest < Test::Unit::TestCase
  
  def setup
    ActiveSearch.options[:api_key] = API_KEY
    @finder = ActiveSearch::Finder.new
    @start_date = Date.new 2011,8,1
    @end_date = Date.new 2011,9,1
  end
  
  
  def test_extract_options
    # keywords
    assert_equal({:keywords => 'running'}, @finder.extract_options(['running']))
    
    # date_range
    assert_equal( {:meta => { :'meta:startDate:daterange:' => "#{@start_date.strftime('%F')}..#{@end_date.strftime('%F')}" }}, 
                  @finder.extract_options([ {:date_range => @start_date..@end_date} ]))
                  
    # date_range, start date only
    assert_equal( {:meta => { :'meta:startDate:daterange:' => "#{@start_date.strftime('%F')}.." }}, 
                  @finder.extract_options([ {:date_range => @start_date} ]))
                  
    start_time = Time.now
    
    # date_range, start time only
    assert_equal( {:meta => { :'meta:startDate:daterange:' => "#{start_time.strftime('%F')}.." }}, 
                  @finder.extract_options([ {:date_range => start_time} ]))
                  
    # media_types
    assert_equal( {:meta => { :'meta:splitMediaType=' => 'Event' }}, 
                  @finder.extract_options([ {:media_type => 'Event'} ]))
                  
    # channel
    assert_equal( {:meta => { :'meta:channel=' => 'Running' }}, 
                  @finder.extract_options([ {:channel => 'Running'} ]))
  end
  
  
  def test_building_search_url
    # keywords
    keywords = 'running'
    assert_equal  url_helper(:k => keywords), 
                  @finder.build_search_url(:keywords => 'running')
                  
    # date_ranges
    assert_equal  url_helper(:m => "meta:startDate:daterange:#{@start_date.strftime('%F')}..#{@end_date.strftime('%F')}"),
                  @finder.build_search_url(:meta => { :'meta:startDate:daterange:' => "#{@start_date.strftime('%F')}..#{@end_date.strftime('%F')}" })
    
    # date_ranges, start date only
    assert_equal  url_helper(:m => "meta:startDate:daterange:#{@start_date.strftime('%F')}.."),
                  @finder.build_search_url(:meta => { :'meta:startDate:daterange:' => "#{@start_date.strftime('%F')}.." })

    start_time = Time.now
    
    # date_ranges, start date only
    assert_equal  url_helper(:m => "meta:startDate:daterange:#{start_time.strftime('%F')}.."),
                  @finder.build_search_url(:meta => { :'meta:startDate:daterange:' => "#{start_time.strftime('%F')}.." })
    
    # media_type
    assert_equal  url_helper(:m => "meta:splitMediaType=Event"),
                  @finder.build_search_url(:meta => { :'meta:splitMediaType=' => 'Event' })
    
    # channel
    assert_equal  url_helper(:m => "meta:channel=Running"),
                  @finder.build_search_url(:meta => { :'meta:channel=' => 'Running' })
    
  end
  
  def test_parsing_dates
  end
  
end
