#!/usr/bin/ruby
require "settings"
require "find"

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

def get_prob_text( prob_num )
  file_name = Settings.prob_dir( prob_num ) + "text"
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
  Find.find( input_dir ){|file_name| input_files << file_name }
  input_files.shift
  return input_files
end
