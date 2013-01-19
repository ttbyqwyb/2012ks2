#!/usr/bin/ruby

require 'rubygems'
require 'cgi'
require 'cgi/session'
require 'pg'
require 'settings'
require 'score'
require 'execution'
require 'functions'

class User
  attr_reader :userid, :username, :score
  def initialize(userid, username, password)
    @userid = userid
    @username = username
    @password = password
  end
  def load_score
    pg = Settings.get_pgconn
    user_search = pg.exec("select * from users where userid = #{@userid}")
    u = user_search[0]
    @score = Score.new(u['score'])
  end
  def save_score
    pg = Settings.get_pgconn
    str = pg.escape(self.score.score_to_str)
    pg.exec("update users set score = '#{str}' where userid = #{@userid};")
  end
  def change_password( old, new )
    if @password != old
      return "Wrong password."
    else
      pg = Settings.get_pgconn
      pg.exec("update users set password = '#{new}' where userid = #{@userid};")
      return "Your password has been changed."
    end
  end
  def answer( args )
    data_dir = Settings::Data_dir
    answer_dir = Settings::Answer_dir
    prob_num = args["prob_num"]
    prob_dir = Settings.prob_dir( prob_num )
    input_dir = Settings.input_dir( prob_num )
    output_dir = Settings.output_dir( prob_num )
    test_files = get_input_files( prob_num )
    text = args["sourcecode"]
    if File.exist?( prob_dir + "time_limit" )
      time_limit = read_file( prob_dir + "time_limit" ).to_s
    else
      time_limit = "1.5"
    end
    language = args["language"]
    if language == "C++"
      ext = ".cpp"
    elsif language == "Ruby"
      ext = ".rb"
    end
    filename = @userid.to_s + "_" + prob_num.to_s + ext
    save_file( answer_dir + filename, text )
    result = Execution.new({
                             "input_dir" => input_dir,
                             "output_dir" => output_dir,
                             "test_files" => test_files,
                             "source_file" => answer_dir + filename,
                             "language" => language,
                             "time_limit" => time_limit
                           }).run()
    self.load_score
    self.score.add_score({ "prob_num" => prob_num.to_s, "verdict" => result["verdict"] })
    self.save_score
    return result
  end
  def prob_list
    list = []
    prob_num = 1
    while File.exist?(Settings.prob_dir(prob_num))
      prob_page = <<HTML
<form method="post" action="prob_page.cgi">
  <input type="hidden" name="prob_num" value="#{prob_num}">
  <input type="submit" value="go">
</form>
HTML
      score_of_this_prob = self.score.get( "prob_num", prob_num.to_s )[0]
      if !score_of_this_prob.nil?
        verdict = score_of_this_prob["verdict"].to_s
      else
        verdict = ""
      end
      hash = { "prob_num" => prob_num,
        "prob_page" => prob_page,
        "text" => read_file(Settings.prob_dir(prob_num)+"text"),
        "verdict" => verdict
      }
      list << hash
      prob_num += 1
    end
    return list
  end
end

def User.load(userid)
  pg = Settings.get_pgconn
  user_search = pg.exec("select * from users where userid = '#{userid}'")
  if user_search.nil?
    print "Non-existing id."
  else
    u = user_search[0]
    return User.new(u['userid'], u['username'], u['password'])
  end
end

def User.add(username, password)
  pg = Settings.get_pgconn
  begin
    pg.exec("insert into users (username, password) values ('#{username}', '#{password}');")
    return true
  rescue PG::Error => ex
    return ex
  end
end
