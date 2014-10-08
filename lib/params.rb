require 'uri'

module RailsOnSails
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params
      
      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
      
      if req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end
    end

    def [](key)
      key = key.to_s
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError
    end

    private
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      
      key_values = URI::decode_www_form(www_encoded_form)
      
      key_values.each do |full_key, value|
        scope = params
  
        keys = parse_key(full_key)
        keys.each_with_index do |key, idx|
          if (idx + 1) == keys.count
            scope[key] = value
          else
            scope[key] ||= {}
            scope = scope[key]
          end
        end    
      end
      
      params
    end

    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
