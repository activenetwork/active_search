require 'cgi'
require 'json'
require 'httparty'

module ActiveSearch
  class Finder
    
    DEFAULT_OPTIONS = { :keywords => nil, :type => 'activities', :format => 'json', :location => nil, :radius => nil, :sort => 'relevance', :meta => nil, :num => nil, :page => nil }
    SEARCH_PARAMS_MAP = { :keywords => 'k', :type => 'f', :format => 'v', :location => 'l', :radius => 'r', :sort => 's', :meta => 'm', :num => 'num', :page => 'page' }
    
    # new finder
    def initialize
    end
    
    
    # actually do the search against the API
    def search(args, throw_errors=false)
      raise ActiveSearch::ApiKeyRequired, "You must specify an API key: ActiveSearch.options[:api_key] = 'your_key_here'" unless ActiveSearch.options[:api_key]
      
      options = DEFAULT_OPTIONS.merge(extract_options(args))
      search_url = build_search_url(options)
      puts search_url
      begin
        response = HTTParty.get(search_url)
        if response.code == 200
          return JSON.parse(response)['_results'].collect { |e| ActiveSearch::Asset.new(e) }
        else
          if throw_errors
            raise ActiveSearch::SearchError, response.body.match(/<h1>(.*?)<\/h1>/)[1]
          else
            return []
          end
        end
      rescue ActiveSearch::SearchError => e
        raise e
      rescue => e
        if throw_errors
          raise ActiveSearch::SearchError, 'Results could not be returned from the remote service'
        else
          return []
        end
      end
    end
    
    
    # build up the URL from the various parts
    def build_search_url(options)
      url = ActiveSearch.options[:url]
      params = { :api_key => ActiveSearch.options[:api_key] }
      options.each do |key,value|
        params.merge! SEARCH_PARAMS_MAP[key] => value unless value.nil?
      end
      full_url = url + '?'
      full_url += params.collect do |k,v| 
        case k
        when 'm'   # meta parameters are nested hashes
          "m=" + v.collect { |j,w| CGI.escape("#{j}#{w.to_s}") }.join('+')
        else
          "#{k}=#{CGI.escape(v.to_s)}"
        end
      end.join('&')
      
      return full_url
    end
    
    
    def scrub_response(events)
      return events.collect { |e| ActiveSearch::Asset.new(e) }
    end
    
    
    def extract_options(args=[])
      options = {}
      if args.first.is_a? Hash
        options = args.first
      else
        if args.last.is_a? Hash
          options = args.last.merge(:keywords => args.first)
        else
          options = { :keywords => args.first }
        end
      end

      if options[:date_range]
        options[:meta] ||= {}
        options[:meta].merge! :'meta:startDate:daterange:' => "#{options[:date_range].first.to_date.strftime('%F')}..#{options[:date_range].last.to_date.strftime('%F')}"
        options.delete :date_range
      end
      
      if options[:media_type]
        options[:meta] ||= {}
        options[:meta].merge! :'meta:splitMediaType=' => options[:media_type]
        options.delete :media_type
      end
      
      return options
    end
    
  end
end
