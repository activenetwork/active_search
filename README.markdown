The active_search gem lets you talk to the Active.com Search API in an awesome Ruby-esque way.

# Usage

You'll need to give the gem your API key before you can start making calls:

  ActiveSearch.options[:api_key] = 12345abcde
  
Now you're ready to make some simple queries, like a keyword search:

  ActiveSearch.find 'running'
  
Want to restrict your results to just San Diego?

  ActiveSearch.find 'running', :location => 'San Diego,CA,US'
  
Note that the search API requires that you pass a country with your city and state.
  
Keywords are optional so if you just want to see everything within 25 miles of the Active.com main office, sorted by date:

  ActiveSearch.find :location => 92121, :radius: 25, :sort => 'date_asc'
  