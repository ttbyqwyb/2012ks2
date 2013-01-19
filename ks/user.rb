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
  def _load_score
    pg = Settings.get_pgconn
    sql = "select * from #{DB::Users} where #{DB::Users_userid} = #{@userid}"
    user_search = pg.exec(sql)
    u = user_search[0]
    @score = Score.new(u['score'])
  end
  def _save_score
    pg = Settings.get_pgconn
    str = pg.escape(self.score.score_to_str)
    sql = "update #{DB::Users} set #{DB::Users_score} = '#{str}' where #{DB::Users_userid} = #{@userid};"
    pg.exec(sql)
  end
  def save_score( args )
    userid = @userid
    prob_num = args["prob_num"].to_i
    date = Time.now.strftime("%x %X")
    verdict = args["verdict"].to_s
    execution_time = args["execution_time"].to_s
    language = args["language"]
    source_code = args["source_code"]
    sql = <<SQL
insert into #{DB::Scores}
(#{DB::Scores_userid}, #{DB::Scores_prob_num}, #{DB::Scores_date}, #{DB::Scores_verdict}, #{DB::Scores_execution_time}, #{DB::Scores_language}, #{DB::Scores_source_code})
values ( '#{userid}', '#{prob_num}', '#{date}', '#{verdict}', '#{execution_time}','#{language}', '#{source_code}');
SQL
    Settings.get_pgconn.exec( sql )
  end
  def load_score( prob_num = nil )
    if prob_num.nil?
      sql_prob_num = ""
    else
      sql_prob_num = "and #{DB::Scores_prob_num} = #{prob_num.to_s}"
    end
    sql = "select * from #{DB::Scores} where #{DB::Scores_userid} = #{@userid}" + sql_prob_num + ";"
    res = Settings.get_pgconn.exec( sql )
    ary = []
    res.each do |col|
      ary << col
    end
    return ary
  end
    
  def change_password( old, new )
    if @password != old
      return "Wrong password."
    else
      pg = Settings.get_pgconn
      sql = "update #{DB::Users} set #{DB::Users_password} = '#{new}' where #{DB::Users_userid} = #{@userid};"
SQL
      pg.exec(sql)
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
    source_code = args["source_code"]
    if File.exist?( Settings.prob_time_limit(prob_num) )
      time_limit = read_file( Settings.prob_time_limit(prob_num) ).to_s
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
    save_file( answer_dir + filename, source_code )
    result = Execution.new({
                             "input_dir" => input_dir,
                             "output_dir" => output_dir,
                             "test_files" => test_files,
                             "source_file" => answer_dir + filename,
                             "language" => language,
                             "time_limit" => time_limit
                           }).run()
    verdict = result["verdict"]
    execution_time = result["execution_time"]
    self.save_score({"prob_num" => prob_num,
                      "verdict" => verdict,
                      "execution_time" => execution_time,
                      "language" => language,
                      "source_code" => source_code})
#    self.load_score
#    self.score.add_score({ "prob_num" => prob_num.to_s, "verdict" => result["verdict"] })
#    self.save_score
    return result
  end
  def prob_list
    list = []
    prob_num = 1
    while File.exist?(Settings.prob_dir(prob_num))
      prob_title = get_prob_title( prob_num )
      prob_page = <<HTML
<form method="post" action="prob_page.cgi">
  <input type="hidden" name="prob_num" value="#{prob_num}">
  <input type="submit" value="go">
</form>
HTML
      score_list = self.load_score(prob_num)
      key = [DB::Scores_date,DB::Scores_verdict,DB::Scores_execution_time,DB::Scores_language,DB::Scores_source_code]
      score = ary_to_table( hashary_to_ary( key, score_list ))
      hash = { "prob_num" => prob_num,
        "prob_title" => prob_title,
        "prob_page" => prob_page,
        "text" => read_file(Settings.prob_dir(prob_num)+"text"),
        "score" => score
      }
      list << hash
      prob_num += 1
    end
    return list
  end
end

def User.load(userid)
  pg = Settings.get_pgconn
  sql = "select * from #{DB::Users} where #{DB::Users_userid} = '#{userid}'"
  user_search = pg.exec(sql)
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
    sql = "insert into #{DB::Users} (#{DB::Users_username}, #{DB::Users_password}) values ('#{username}', '#{password}');"
    pg.exec(sql)
    return true
  rescue PG::Error => ex
    return ex
  end
end
