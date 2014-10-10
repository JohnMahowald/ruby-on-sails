# Rails On Sails

Rails on Sails is an exercise in meta programming where I learned how Rails handles web requests and serves responses. In this app I build a module, RailsOnSails, which clones the basic functionality of Rails' controller_base, router, session handler and params hash.

## Key Features:
1. Router uses Ruby's define_method to create custom routes for each incoming HTTP request. When called, the router invokes the correlated controller action.
2. Parses HTTP request's query string to follow convention for Rails nested params hash.
3. Uses string interpolation to write the file path for rendering an ERB template to be served in the HTTP response.

## To Run:

1. Clone Repo.
2. Bundle install.
3. Run 'ruby bin/params_server.rb' to start the server.
4. Navigate to 'localhost:3000/cats' or 'localhost:3000/cats/new'.
5. Run the specs!

## About:

To learn more about me and my work as a developer, please visit my website at: [www.johnmahowald.com](http://www.johnmahowald.com)