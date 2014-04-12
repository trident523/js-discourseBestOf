##js-discourseBestOf##

>##Hey! You should check out the [official way to do this.][8] This script probably still works, but I'm no longer maintaining it.




**js-discourseBestOf** is a jQuery based wrapper for the  [wp-discourse](https://github.com/discourse/wp-discourse "wp-discourse") plugin for [discourse](https://github.com/discourse/discourse). 

Read about it! [at it's place on meta.discourse.org](http://meta.discourse.org/t/discourse-plugin-for-static-site-generators-like-jekyll-or-octopress/7965/16)

This is just the javascript part, for developers who don't need the jekyll intergration. Create a div tag with ID of comments, and a topic ID and it'll do the rest.

For example:
```
<div id="comments" tid="200"></div>
```
will populate the div tag with the "best" posts of topic ID 200, as specified in the javascript file.

You need to set the Access-Control-Allow-Origin header for discourse. That's as simple as:
```
add_header "Access-Control-Allow-Origin" "*";
```
in nginx!

This allows all sites to load your content via javascript. If you would like, replace the * with the public location of your jekyll install, including http://. The security of this is debated all over, but I find it safe. For more security, add the header only to your json files using a location block!

Read the guide over [here for how to intergrate the two together.][7]

<h3> Extra Notes </h3>
I've detailed some of the implementation in the posts above, but if you use some other kind of site generator all you need to create is a div/span with an ID of comments, and an attritube called "tid." Then, you can just load the javascript and comments will render in that space. The topic ID is the number that follows after `/t/<post-slug>/` and is not the last number. 

And if you're really looking to build it out in some other kind of framework I'd recommend looking at the original [wp-discourse][6]. Or, just load up `/t/<topicID>/wordpress.json?best=number` and parse it from there.


  [1]: https://github.com/trident523/js-discourseBestOf
  [2]: https://github.com/discourse/wp-discourse
  [3]: http://meta.discourse.org/users/sam
  [4]: http://benalman.com/code/projects/php-simple-proxy/docs/files/ba-simple-proxy-php.html
  [5]: http://temp.trid.in:8080/
  [6]: https://github.com/discourse/wp-discourse
  [7]: https://github.com/trident523/jekyll-DiscourseBestOf
  [8]: http://eviltrout.com/2014/01/22/embedding-discourse.html

