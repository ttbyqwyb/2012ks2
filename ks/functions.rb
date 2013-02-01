#!/usr/bin/ruby
require "settings"

def save_file( pass, text )
  open( pass, "w" ){|fh|
    fh.binmode
    fh.write text
  }
end

def read_file( pass )
  if File.exist?( pass )
    return open( pass ).read
  else
    return nil
  end
end

def get_prob_title( prob_num )
  file_name = Settings.prob_title( prob_num ) 
  title = read_file( file_name )
  if title.nil?
    return "-"
  else
    return title
  end
end

def get_prob_text( prob_num )
  file_name = Settings.prob_text( prob_num ) 
  text = read_file( file_name )
  if text.nil?
    return "The file \"#{ file_name }\" does not exist."
  else
    return text
  end
end

def get_input_files( prob_num )
  input_dir = Settings.input_dir( prob_num )
  input_files = []
  Dir.glob( input_dir + "*" ){|file_name| input_files << file_name.gsub(/.*\//,"") }
  return input_files
end

def save_msg( args )
  if args.class == Hash
    title = args["title"]
    msg = args["msg"].to_s
  else
    title = ""
    msg = args.to_s
  end
  time = Time.now.strftime("%x %X")
  pg = Settings.get_pgconn
  msg = pg.escape_string(msg)
  sql = <<SQL
insert into #{DB::Messages}
(#{DB::Messages_time}, #{DB::Messages_title}, #{DB::Messages_msg})
values ('#{time}', '#{title}', '#{msg}');
SQL
  pg.exec(sql)
end

def load_msg
  pg = Settings.get_pgconn
  res = pg.exec("select * from #{DB::Messages};")
  ary = []
  res.each do |col|
    ary << col
  end
  return ary
end

def delete_msg
  pg = Settings.get_pgconn
  pg.exec("truncate table #{DB::Messages};")
end

def get_scoreid
  pg = Settings.get_pgconn
  sql = <<SQL
insert into #{DB::Scores}
(#{DB::Scores_verdict})
values ('');
SQL
  pg.exec( sql )
  sql = "select last_value from #{DB::Scores}_#{DB::Scores_scoreid}_seq;"
  answer_num = pg.exec(sql)[0]["last_value"].to_i
  return answer_num
end
