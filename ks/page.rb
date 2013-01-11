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
  <form method="post" action="login.cgi">
    username
    <input type="text" name="username"/><br>
    password
    <input type="password" name="password"/>
    <input type="submit" value="Login"/>
  </form>
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
    user.load_score
    key = user.score.key
    score = user.score.score
    ary = hashary_to_ary( key, score )
    table = ary_to_table( ary )
    ret = ""
    ret += <<HTML
<html>
<head>
  <title>Home</title>
</head>
<body>
  <p>id: <b>#{user.userid}</b>, name: <font size="5"><b>#{user.username}</b></font></p>
  <p>
  <form method="post" action="upload.cgi" enctype="multipart/form-data">
    <input type="file" name="file"/>
    <input type="submit" value="submit file"/>
  </form>
  </p>
  <p>
    score list<br>
    #{table}
  </p>
  <p>
    <a href="./answer_page.html">answer</a>
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
