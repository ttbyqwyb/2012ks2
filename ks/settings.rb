#!/usr/bin/ruby

require 'rubygems'
require 'pg'

module DB
  DB_name = "test"
  DB_user = "postgres"
  DB_password = "topology"
  
  Users = "users"
  Users_userid = "userid"
  Users_username = "username"
  Users_password = "password"
  Users_columns = [Users_userid,Users_username,Users_password]

  Scores = "scores"
  Scores_scoreid = "scoreid"
  Scores_userid = "userid"
  Scores_prob_num = "prob_num"
  Scores_date = "date"
  Scores_verdict = "verdict"
  Scores_execution_time = "execution_time"
  Scores_language = "language"
  Scores_source_code = "source_code"
  Scores_columns = [Scores_scoreid,Scores_userid,Scores_prob_num,Scores_date,Scores_verdict,Scores_execution_time,Scores_language,Scores_source_code]

  Messages = "messages"
  Messages_msgid = "msgid"
  Messages_time = "time"
  Messages_title = "title"
  Messages_msg = "msg"
  Messages_columns = [Messages_msgid,Messages_time,Messages_msg]
end

module Settings
  #directories
  Data_dir = "./data/"
  Answer_dir = Data_dir + "answer/"
  def prob_dir( prob_num )
    return Data_dir + "prob" + prob_num.to_s + "/"
  end
  def input_dir( prob_num )
    return prob_dir( prob_num ) + "in/"
  end
  def output_dir( prob_num )
    return prob_dir( prob_num ) + "out/"
  end
  def prob_title( prob_num )
    return prob_dir( prob_num ) + "title"
  end
  def prob_text( prob_num )
    return prob_dir( prob_num ) + "text"
  end
  def prob_time_limit( prob_num )
    return prob_dir( prob_num ) + "time_limit"
  end
  
  # session.rb cmd_tuples
  False_in_my_PC = false

  # in execution.rb
  Daemon = "www-data"

  def get_pgconn()
    pg = PG::Connection.connect('localhost', 5432, '', '', DB::DB_name, DB::DB_user, DB::DB_password )
    return pg
  end
  module_function :get_pgconn, :prob_dir, :input_dir, :output_dir, :prob_title, :prob_text, :prob_time_limit
end
