use strict;
use warnings;

use HTML::Escape;

sub base {
    my ($res,$title,$cont) = @_;
    my $page = <<"EOS"
	
<html>
  <head>
    <meta charset="utf8"/>
    <link rel="stylesheet" type="text/css" href="/css/s.css" />
    <title><%== $thread->{title} %> -- Truth Avaliable</title>
  </head>
  <body>
    <nav id="navbar" class="navbar">
    <div id="navbar-left">
      <a id="navbar-brand">
        Truth Avaliable
      </a>
    
      <ul class="navbar-links">
        <li><a href="/">Index</a></li>
	<li><a href="#">Categories</a></li>
	<li><a href="#">Tags</a></li>
      </ul>
    </div>

    <div id="navbar-right">
      <ul class="navbar-links">
        <li><a href="javascript:;">New</a></li>
	<li class="nav-dropdown">
	  <a href="javascript:;" class="nav-dropdown-link">ExampleUser</a>
	  <ul class="nav-dropdown-menu">
	    <li><a href="javascript:;">User Center</a></li>
	    <li class="nav-dropdown-sep"></li>
	    <li><a href="javascript:;">Logout</a></li>
	  </ul>
	</li>
      </ul>
    </div>
  </nav>
  <div class="header" id="header">
EOS
    $page .= '<h1>'.escape_html($thread->{title}).'</h1><span>on $thread->{datetime}->ymd("/") %> by <%== $tauthor->{name} %></span>'
    </div>
    
    % if ($has_prev or $has_next) {
    <ul class="pager">
      % if ($has_prev) {
      <li><a href="/thread/view/<%= $thread->{_id} %>/<%= $pn - 1 %>">&lt;Prev</a></li>
      % }
      % if ($has_next) {
      <li><a href="/thread/view/<%= $thread->{_id} %>/<%= $pn + 1 %>">Next&gt;</a></li>
      % }
    </ul>
    % }

    <% my $floor = ($pn - 1) * 30; %>
    <div class="posts" id="posts">
      % for (@posts) {
      <%
      my $post = $_;
      $floor++;
      my $pauthor = $ucoll->find({_id => $post->{author}})->next;
      %>
      <div class="post">
        <div class="author">
          <div class="avatar">
	    % my $email = $pauthor->{email};$email =~ s/^\s+|\s+$//g;
            <img src="http://www.gravatar.com/avatar/<%== md5_hex(lc($email)) %>?size=140"/>
          </div>

          <span><%== $pauthor->{name} %></span>
        </div>

        <div class="post-body">
          <div class="body-header">
            <div class="info">
              <span>No.<%== $floor %> </span><span>posted on <%== $post->{datetime}->strftime("%Y/%m/%d %H:%M:%S") %></span>
            </div>
            <ul class="post-ops">
              <li><a href="javascript:;">Reply</a></li>
            </ul>
          </div>
        
          <div class="post-content">
	    <%= Render::render($post) %>
          </div>
        </div>
      </div>
      % }
          % if ($has_prev or $has_next) {
      <ul class="pager">
	% if ($has_prev) {
	<li><a href="/thread/view/<%= $thread->{_id} %>/<%= $pn - 1 %>">&lt;Prev</a></li>
	% }
	% if ($has_next) {
	<li><a href="/thread/view/<%= $thread->{_id} %>/<%= $pn + 1 %>">Next&gt;</a></li>
	% }
      </ul>
    % }
    </div>
    <script src="/js/nav-dropdown.js"></script>
    <script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
  </body>
</html>
        
