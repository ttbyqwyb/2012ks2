require 'rubygems'
require 'cgi'
require 'pg'
require 'user'
require 'table'

class LoginPage
  def initialize(args)
    @args = args
  end
  def page()
    error_msg = @args['error_msg']
    ret = ""
    ret += <<HTML
<html>
<head>
  <title>Login</title>
</head>
<body>
  <p>
    <b>Login</b>
    <div style="border-style:solid;border-width:1px;padding:10px">
      <form method="post" action="login.cgi">
	username
	<input type="text" name="username"/><br>
	password
	<input type="password" name="password"/><br>
	<input type="submit" value="Login"/><br>
      </form>
    </div>
  </p>
  <p>
    <b>Create new account</b>
    <div style="border-style:solid;border-width:1px;padding:10px">
      <form method="post" action="user_add.cgi">
	username
	<input type="text" name="username"><br>
	password
	<input type="password" name="password"><br>
	<input type="submit" value="add"><br>
      </form>
    </div>
  </p>
  <p>#{error_msg}</p>
</body>
</html>
HTML
    return ret
  end
end

class HomePage
  def initialize(args)
    @args = args
  end
  def page()
    user = @args['user']
#    user.load_score
#    key = user.score.key
    key = ["prob_num", "prob_title", "prob_page", "score"]
    prob_list = user.prob_list
    prob_table = ary_to_table( hashary_to_ary( key ,prob_list ))
    ret = ""
    ret += <<HTML
<html>
<head>
  <title>Home</title>
</head>
<body>
  <p>id: <b>#{user.userid}</b>, name: <font size="5"><b>#{user.username}</b></font></p>
  <p>
    prob list<br>
    #{prob_table}
  </p>
  <p>
    <a href="change_password.html">Change password</a>
    <a href="logout.cgi">LogOut</a>
  </p>
</body>
</html>
HTML
    return ret
  end
end

class LogoutPage
  def page()
    ret = <<HTML
<html>
  <head>
    <title>Logout</title>
  </head>
  <body>
    <p>Logout succeeded.</p>
    <p>
      <a href="./login_page.cgi">LoginPage</a>
    </p>
  </body>
</html>
HTML
    return ret
  end
end

class ResultOfUpload
  def initialize(args)
    @args = args
  end
  def page()
    filename = @args['filename']
    text = @args['text']
    ret = <<HTML
<html>
  <head>
    <title>ResultOfUpload</title>
  </head>
  <body>
    <p>
      The file #{filename} was successfully uploaded!!!<br>
    </p>
    <p><a href="./home.cgi">Back to home.</a></p>
    <p>
      #{text}
    </p>
  </body>
</html>
HTML
    return ret
  end
end
