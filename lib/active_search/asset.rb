module ActiveSearch
  class Asset
    
    attr_reader :raw, :data
    
    DEFAULTS = {  :url          => nil, 
                  :title        => nil, 
                  :address      => nil,
                  :city         => nil, 
                  :state        => nil, 
                  :zip          => nil,
                  :country      => nil,
                  :latitude     => nil,
                  :longitude    => nil,
                  :summary      => nil, 
                  :start_date   => nil,
                  :end_date     => nil,
                  :asset_id     => nil,
                  :channels     => nil,
                  :media_types  => nil,
                  :image        => nil,
                  :byline       => nil,
                  :tags         => [] }
    
    def initialize(data)
      @raw = data
      # @ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      
      @data = DEFAULTS.merge( :url     => @raw['url'],
                              :title   => scrub_title(@raw['title']))
                      
      if @raw['meta']
        @data.merge!( :address      => @raw['meta']['address'],
                      :city         => @raw['meta']['city'],
                      :state        => @raw['meta']['state'],
                      :zip          => @raw['meta']['zip'],
                      :country      => @raw['meta']['country'],
                      :latitude     => @raw['meta']['latitude'].to_f,
                      :longitude    => @raw['meta']['longitude'].to_f,
                      :summary      => scrub_summary(@raw['meta']['summary']),
                      :start_date   => scrub_date(@raw['meta']['startDate']),
                      :end_date     => scrub_date(@raw['meta']['endDate']),
                      :asset_id     => scrub_asset_id(@raw['meta']['assetId']),
                      :title        => scrub_title(@raw['meta']['assetName']),      # if the asset has an actual assetName, use that as the :title
                      :channels     => [@raw['meta']['channel']].flatten,
                      :media_types  => [@raw['meta']['splitMediaType']].flatten,
                      :image        => @raw['meta']['image2'],
                      :byline       => @raw['meta']['byline'],
                      :tags         => [@raw['meta']['tag']].flatten)
      end
      
    end
    
    
    def method_missing(method_id, *args)
      if @data.has_key? method_id
        @data[method_id]
      else
        super
      end
    end
    
    
    #def to_s
    #  @raw.inspect
    #end
    
    
    # some replacements specific to the title of an event
    def scrub_title(text)
      text = text.is_a?(Array) ? text.first : text
      text = text.chars.select{|i| i.valid_encoding?}.join.split('|').first.gsub(/&amp;/, '&').gsub(/<.*?>/,'').gsub(/&#39;/, "'").gsub(/\?/,'') if text.present?
      return text
    end
    private :scrub_title
    
    
    def scrub_summary(text)
      return text.chars.select{|i| i.valid_encoding?}.join.gsub(/&#39;/, "'").gsub(/&amp;/,'&').gsub(/<.*?>/,'').gsub('...','').gsub('?',"'").strip if text.present?
    end
    private :scrub_summary
    
    
    def scrub_date(text)
      return text.nil? ? nil : (text.is_a?(Array) ? Date.parse(text.first) : Date.parse(text))
    end
    private :scrub_date
    
        
    def scrub_asset_id(text)
      return (text.is_a?(Array) ? text.first : text).downcase
    end
    private :scrub_asset_id
    
  end
end