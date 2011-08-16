$:.unshift File.dirname(__FILE__) # for use/testing when no gem is installed

require 'test/unit'
require 'active_search'

API_KEY = YAML.load(File.read(File.expand_path('options.yml')))['api_key']

def url_helper(options={})
  url = "#{ActiveSearch.options[:url]}?api_key=#{API_KEY}&"
  url += options.collect { |k,v| "#{k.to_s}=#{CGI.escape(v.to_s)}" }.join('&')
  return url
end