module RailsLite
  class ControllerBase
    attr_reader :req, :res, :params

    # Setup the controller
    def initialize(req, res, route_params = {})
      @req, @res = req, res
      @already_built_response = false
      @params = Params.new(req, route_params)
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      raise 'Error!' if already_built_response?
      
      @res.status = 302
      @res['Location'] = url
      
      @already_built_response = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      raise 'Error!' if already_built_response?
      
      @res.body = content
      @res.content_type = type
      
      @already_built_response = true
    end
    
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      controller_name = self.class.name.underscore
      file_path = "views/#{controller_name}/#{template_name}.html.erb"
      
      content = File.read(file_path)
      template = ERB.new(content).result(binding)
    
      render_content(template, 'text/html')
    end
    
    def redirect_to(url)
      super(url)
      session.store_session(@res)
    end

    def render_content(content, type)
      super(content, type)
      session.store_session(@res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
    
    def invoke_action(name)
      self.send(name)
    end
  end
end