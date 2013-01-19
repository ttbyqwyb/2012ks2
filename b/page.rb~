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
    <input type="submit" value="submit filee"/>
  </form>
  </p>
</body>
</html>
HTML
    return ret
  end
end


