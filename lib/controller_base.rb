require 'active_support/core_ext'
require_relative './session'
require_relative './params'

module RailsOnSails
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
      session.store_session(@res)
      
      @already_built_response = true
    end
    
    def render(template_name)
      controller_name = self.class.name.underscore
      file_path = "views/#{controller_name}/#{template_name}.html.erb"
      
      content = File.read(file_path)
      template = ERB.new(content).result(binding)
    
      render_content(template, 'text/html')
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      raise 'Error!' if already_built_response?
      
      @res.body = content
      @res.content_type = type
      session.store_session(@res)
      
      @already_built_response = true
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