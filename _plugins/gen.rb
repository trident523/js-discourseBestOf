require 'httparty'
require 'json'
require 'pstore'

module Jekyll
  class RenderTimeTag < Liquid::Tag

    def render(context)
	goodtogo = false
	if (Jekyll.configuration({})['discourse_api_key'].nil?)
		raise "API key not set in config! Please set discourse_api_key"
	end

	stor = PStore.new("discourse/" + context.environments.first["page"]["title"] + ".pstore")	

	if(!File.exist?("discourse/" + context.environments.first["page"]["title"] + ".pstore"))
		puts "We're making a new post for title:" + context.environments.first["page"]["title"]
		@result = HTTParty.post(Jekyll.configuration({})['discourse_api_url'] + "/posts", 
	        :body => { :api_key => Jekyll.configuration({})['discourse_api_key'], 
            		   :api_username => Jekyll.configuration({})['discourse_api_username'], 
	   		   :title => context.environments.first["page"]["title"], 
			   :raw => context.environments.first["page"]["content"], 
			   :category => Jekyll.configuration({})['discourse_api_category'],
			   :skip_validations => 'true'
             		 }.to_json,
			    :headers => { 'Content-Type' => 'application/json' } );
	
			parsing = JSON.parse(@result.body);

			stor.transaction do
				stor['topic_id'] = parsing['topic_id']
			end

		parsing['id']
	end
	
	else
		found = -1
		stor.transaction do
			found = stor['topic_id']
		end
		"tid = \"#{found}\""
	end
    end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)
