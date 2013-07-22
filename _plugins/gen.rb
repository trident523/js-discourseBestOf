require 'httparty'
require 'json'
require 'pstore'

module Jekyll
  class DiscourseComments < Liquid::Tag

        def render(context)
                if (Jekyll.configuration({})['discourse_api_key'].nil?)
                        raise "API key not set in config! Please set discourse_api_key"
                end
                stor = PStore.new("_discourse/" + context.environments.first["page"]["title"].gsub('/','slash') + ".pstore")
                posted = false
                found = -1
                @sleep = 0
                if(!File.exist?("_discourse/" + context.environments.first["page"]["title"].gsub('/','slash') + ".pstore"))
                until posted
                        sleep @sleep
                        puts "We're making a new post for title:" + context.environments.first["page"]["title"].gsub('/','slash')
                        @result = HTTParty.post(Jekyll.configuration({})['discourse_api_url'] + "/posts",
                        :body => { :api_key => Jekyll.configuration({})['discourse_api_key'],
                           :api_username => Jekyll.configuration({})['discourse_api_username'],
                           :title => context.environments.first["page"]["title"],
                           :raw => "From the blog: " + context.environments.first["page"]["title"] + "\n" + Jekyll.configuration({})['url'] + context.environments.first["page"]["url"] + ")",
                           :category => Jekyll.configuration({})['discourse_api_category'],
                           :skip_validations => 'true'
                         }.to_json,
                            :headers => { 'Content-Type' => 'application/json' } );

                        if(!@result['errors'])
                                parsing = JSON.parse(@result.body);
                                found = parsing['topic_id']
                                stor.transaction do
                                        stor['topic_id'] = parsing['topic_id']
                                end
                                posted = true
                        else
                                puts "\033[31m" + "We got these errors from discourse: " + "\033[0m"
                                puts "\033[35m"
                                puts @result['errors']
                                puts "\033[0m"
                        if(@result.code == 429)
                                puts "We were asked to slow down! Re-trying in: " + @sleep + " seconds."
                                @sleep += 5
                        else
                                raise "Other API error"
                        end
                end
                end
        else
                stor.transaction do
                        found = stor['topic_id']
                end
                posted = true
        end
            "tid = \"#{found}\""
    end
  end
end

Liquid::Template.register_tag('discourse_comments', Jekyll::DiscourseComments)
