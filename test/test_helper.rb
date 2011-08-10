require 'test/unit'
require 'active_search'

API_KEY = YAML.load(File.read(File.expand_path('options.yml')))['api_key']
