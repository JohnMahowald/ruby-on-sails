require 'json'
require 'webrick'

module RubyOnSails
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @cookie = {}
      
      req.cookies.each do |cookie|
        @cookie = JSON.parse(cookie.value) if cookie.name == '_ruby_on_sails_app'
      end
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new(
        '_ruby_on_sails_app',
        @cookie.to_json
      )
    end
  end
end
