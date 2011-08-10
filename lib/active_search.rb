$:.unshift File.dirname(__FILE__) # for use/testing when no gem is installed

require 'active_search/finder'
require 'active_search/asset'

module ActiveSearch
  
  # error classes
  class SearchError < StandardError; end
  
  attr_accessor :options
  
  @options = {  :url => nil, 
                :api_key => nil }
  
  # make @options available so it can be set externally when using the library
  extend self
  
  # performs a search. This version will mask any errors that are returned when querying the service
  def find(*args)
    @finder ||= Finder.new
    @finder.search(args, false)
  end
  
  # performs a search, but will throw an error if invalid results are turned from the API (or it stops responding, or times out, etc.)
  def find!(*args)
    @finder ||= Finder.new
    @finder.search(args, true)
  end
  
end
