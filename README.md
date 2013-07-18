##js-discourseBestOf##

**js-discourseBestOf** is a jQuery based wrapper for the  [wp-discourse](https://github.com/discourse/wp-discourse "wp-discourse") plugin for [discourse](https://github.com/discourse/discourse). 

Read about it! [at it's place on meta.discourse.org](http://meta.discourse.org/t/discourse-plugin-for-static-site-generators-like-jekyll-or-octopress/7965/16)

This plugin combines javascript loaded on the page with a Liquid tag, written for jekyll to generate posts from your jekyll site, and then load the "best" comments from your discourse install. The only thing you have to bring to the table is some fancy CSS, as every jekyll site is different. Comments are created with IDs of "post#" starting at 1. Comments need to live in a div with an ID of "comments."

----------

<h3>Great! Let's go!</h3>

Now hold on for just a second. One of the big limitations of javascript is that it can not just pull data from another domain/subdomain. To have comments that update after your site is generated, we need to have something load them. So, we have to use one of two work-arounds to get past this. Our first option is to simply add a header to every response your server sends, permitting javscript to simply load across this restriction. However, the downsides to this are that you have to change settings with nginx/apache. 

Your other option is to collect, with server-side code the responses we need. The major downside to this is you will have to allow non-static code to run where your static jekyll site lives. Kind of defeats the point in some ways. This part will be documented *some time soon* and is a valid way if the headers are not working out.  If you've configured PHP, [this is a script that will accomplish what's needed.][4] You'll need to convert just the javascript request to be URL encoded.

For the first approach, follow the steps below. The second approach will require an edit to the javascript, and those directions will be at the bottom.

<h3>Preparing Discourse</h3>

You'll need your API key handy (found in the admin section), and may want to create a category where posts will live. We next need to add a line of configuration to your config for nginx. The install guide leads you to create it in `conf.d/discourse.conf`.  

    add_header "Access-Control-Allow-Origin" "*";

This allows all sites to load your content via javascript. If you would like, replace the * with the public location of your jekyll install, including http://. The security of this is debated all over, but I find it safe. For more security, add the header only to your json files using a location block!

<h4>Not Reccomended: PHP proxy instead of CORS Header</h4>

I don't reccomend this approach at first, because it can create some security issues if your script is not secured. This likely won't happen... but you never really know. This is the php script.

Edit line 19 of js-discourse.js from:

    BASE_URL + '/t/' + $('.comments').attr('tid') + '/wordpress.json?best=' + COMMENTS
to:

    'http://<your-blog-url>/ba-simple.proxy.php?url=http%3A%2F%2F' + BASE_URL + '%2Ft%2F' + $('.comments').attr('tid') +'%2Fwordpress.json%3Fbest%3D' + COMMENTS

Then, replace every instance of a.posts with a.contents.posts.

<h3>Preparing Octopress</h3>

This plugin requires httparty, a cool gem that makes HTTP requests easy. It also requires json, which is likely installed. We'll double check by adding it anyway. To install it, simply remove your `Gemfile.lock`, and to your `Gemfile` add the lines below, and run a bundle install. You can't just use gem install to do it.

    gem 'httparty'
    gem 'json'


<h3>Preparing Jekyll</h3>
*If you didn't install httparty and json above, do it here with:*

    gem install httparty json

You'll need the plugin files. Download them from the repository above. For a very basic jekyll install, this is as simple as taking my repository and placing it on top of your main jekyll folder. 

For octopress, the ruby file in _plugins moves to just plugins, and the javascript file moves to source/javascripts. For the rest of this guide, we'll work in this folder.
### Javascript Guide ###


* Add the javascript file in /javascripts/ to your source folder.
* Edit your ```/source/_includes/custom/head.html```  file to include this script. jQuery is included with Octopress. As long as it's placed on your posts page it should work, but it'd be best to put it in the header. Here's an example, assuming you placed the files in the source folder. 

```diff
+<script src="//code.jquery.com/jquery-2.0.0.js"></script> *if you need jQuery*
+<script src="/javascripts/js-discourse.js"></script>
```

* Edit your posts.html to include the below somewhere. Feel free to re-write the noscript tag.

```diff
+<h1>Comments</h1>
+<div id="comments" style="padding-left:35px; padding-right:35px" {% discourse_comments %}></div>
+<noscript>Javascript is off, so comments don't load.</noscript>
```

In octopress, you can remove:

```diff
-{% if site.disqus_short_name and page.comments == true %}
-  <section>
-    <h1>Comments</h1>
-    <div id="disqus_thread" aria-live="polite">{% include post/disqus_thread.html %}</div>
-  </section>
-{% endif %}
```
 and include the above code.

When the pages are created, this will add an attribute to the div tag called "tid", which holds the related topic ID. We're also loading the script right before it. This should probably be moved to your header instead, but for now let's keep moving. 

Back out of your source directory, and create a directory called `_discourse`. Next, edit your `_config.yml` to include:

    discourse_api_key: Your api key
    discourse_api_username: Username to post as
    discourse_api_category: Category to post to
    discourse_api_url: The URL of your discourse install, include http:// and no trailing slash.

Remember that spacing in a yaml file is important. Each entry is a new line, and one space after the colon.

Next, edit `js-discourse.js` and view the configuration at the top. Remember that java-script is run client side, so setting the update time low will hammer your server from many locations.

To recap:

1. Add Access-Control headers to your nginx/apache config.
2. Install httparty and json. Edit your Gemfile if you use one, otherwise install directly.
3. Add the liquid tag to whatever layout you want comments for.
4. Add needed information to your configuration yaml file.
5. Add needed information to `js-discourse.js` 
6. Generate your site!

**Congrats! You made it**. You should be able to generate your site and all of your posts will sync. It's important to note that the folder you created stores a `pstore` file with the title of your post. If it can't find these for some reason, when you generate you will create new posts with duplicated content. While it won't delete the old posts, you'll find that it will load comments from your newly duplicated post instead of the old one. Treat these files just like your database, carefully!

It looks something like [this.][5] I didn't style the output yet, though.

----------

<h2>Stuff I want to fix!</h3>
1. I take the posts full contents over to discourse with no attempts to check the limits. If you don't write a lot you might like this, otherwise maybe we will both find what happens when you use the API to make a really long post! You might have to edit them down by hand for now. 
2. Formatting assumes markdown. 
3. It actually runs twice per post, for reasons I can't figure out. 

----------
<h3> Extra Notes </h3>
I've detailed some of the implementation in the posts above, but if you use some other kind of site generator all you need to create is a div/span with an ID of comments, and an attritube called "tid." Then, you can just load the javascript and comments will render in that space. The topic ID is the number that follows after `/t/<post-slug>/` and is not the last number. 

And if you're really looking to build it out in some other kind of framework I'd recommend looking at the original [wp-discourse][6]. Or, just load up `/t/<topicID>/wordpress.json?best=number` and parse it from there.


  [1]: https://github.com/trident523/js-discourseBestOf
  [2]: https://github.com/discourse/wp-discourse
  [3]: http://meta.discourse.org/users/sam
  [4]: http://benalman.com/code/projects/php-simple-proxy/docs/files/ba-simple-proxy-php.html
  [5]: http://temp.trid.in:8080/
  [6]: https://github.com/discourse/wp-discourse



### Let me see it in action! ###
Okay! [Check it out.](http://temp.trid.in:8080/blog/2013/07/01/title/) I don't actually have any content, but why not go for it. 
I'm sure there's more that can be added, like avatars. However, I wanted to keep the concept fairly simple so it can be expanded by other users. Please contribute any suggestions you have to me, either here or on [meta.discourse.org](http://meta.discourse.org/users/trident). Or, make a pull request!
