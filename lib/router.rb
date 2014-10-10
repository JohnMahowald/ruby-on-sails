module RubyOnSails
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method = pattern, http_method
      @controller_class, @action_name = controller_class, action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      req_method = req.request_method.downcase.to_sym
      (@http_method == req_method) && !(req.path =~ @pattern).nil?
    end

    # use pattern to pull out route params
    # instantiate controller and call controller action
    def run(req, res)
      match_data = @pattern.match(req.path)
      
      router_params = {}
      match_data.names.each do |name|
        router_params[name] = match_data[name]
      end
      
      @controller_class
        .new(req, res, router_params)
        .invoke_action(@action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    def draw(&proc)
      self.instance_eval(&proc)
    end
    
    # On initialize creates four methods for handling incoming router requests.
    # Creates a method that when called, adds a route to the @routes array.
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    def match(req)
      @routes.each do |route|
        return route if req.path =~ route.pattern
      end
      
      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      matched_route = self.match(req)
      matched_route.nil? ? res.status = 404 : matched_route.run(req, res) 
    end
  end
end
