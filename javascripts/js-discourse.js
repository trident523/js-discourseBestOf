//Number of Comments
var COMMENTS = 4;
//Update time, default is 5 min. This jumps the user's position a little on the page, so don't set it super low.
var UPDATE_TIME = 300000;
//URL to your forums. Exclude traling slash! ex: http://meta.discourse.org
var BASE_URL = "http://forums.cityfellas.com";

//In the future, it might be worth comparing the topic creator ID with one hard coded here.
//Stuff NOT to change!
var TITLE = $(document).attr('title').toLowerCase();
var SLUG = TITLE.substring(0, TITLE.lastIndexOf('-'));
var scroll = $(window).scrollTop();
var grv;
$(document).ready(function go() {
$('#comments').html('Loading...');
        try {
            $.getJSON(BASE_URL + '/t/' + $('#comments').attr('tid') + '/wordpress.json?best=' + COMMENTS, function (a) {
                if (a.posts) {
                    $('#comments').html('');

                    $.each(a.posts, function (i, v) {
                        $('#comments').append("<div id=\"toset\">" + "<img width=\"45\" id=\"grav" + i + "\">" + "<b>" + a.posts[i].name + "</b>" + "  said  " + a.posts[i].cooked + "</div>" + "<hr>");
                        grv = a.posts[i].avatar_template.replace('\{size\}', "45");
                        $('#grav' + i).attr('src', grv);
                        $('#toset').attr('id', 'post' + i);
                    });
                    $('#comments').append("<p> Keep chatting about this post at <a id=\"togo\"> the forums.</a> There are " + (a.filtered_posts_count - a.posts.length - 1) + " other replies.");
                    $('#togo').attr('href', BASE_URL + '/t/' + $('#comments').attr('tid'));
                } else {
                    $('#comments').html("No responses yet. Go start the discussion at " + "<a id=\"boardurl\">" + "the forums." + "</a>");
                    $('#boardurl').attr('href', BASE_URL);
                }
            });
        } catch (err) {
            $('#comments').html("Nothing close to this page title. Go start the discussion at " + "<a id=\"boardurl\">" + "the forums." + "</a>");
            $('#boardurl').attr('href', BASE_URL);
        }
    $("html").scrollTop(scroll);
    setTimeout(go, UPDATE_TIME);
});

