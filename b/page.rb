require 'rubygems'
require 'cgi'
require 'pg'
require 'member'

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
    <input type="text" name="username"/>
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
    member = @args['member']
    ret = ""
    ret += <<HTML
<html>
<head>
  <title>Home</title>
</head>
<body>
  <p>You are #{member.username}, userid:#{member.userid}. </p>
  <p>
  <form method="post" action="upload.cgi" enctype="multipart/form-data">
    <input type="file" name="file"/>
    <input type="submit" value="submit file"/>
  </form>
  </p>
  <p>
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
      <a href="./login.cgi">LoginPage</a>
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
