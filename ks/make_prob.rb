#!/usr/bin/ruby

require "settings"
require "functions"

def make_prob( args )
  prob_num = args["prob_num"].to_i
  title = args["title"].to_s
  text = args["text"].to_s
  inputs = args["inputs"]
  outputs = args["outputs"]
  time_limit = args["time_limit"].to_s
  Dir.mkdir( Settings.prob_dir(prob_num) )
  Dir.mkdir( Settings.input_dir(prob_num) )
  Dir.mkdir( Settings.output_dir(prob_num) )
  save_file( Settings.prob_title(prob_num), title )
  save_file( Settings.prob_text(prob_num), text )
  save_file( Settings.prob_time_limit(prob_num), time_limit )
  input_dir = Settings.input_dir( prob_num )
  output_dir = Settings.output_dir( prob_num )
  if inputs.class == Array
    for i in 1..(inputs.length)
      save_file( input_dir + i.to_s , inputs[i-1].to_s )
      save_file( output_dir + i.to_s , outputs[i-1].to_s )
    end
  end
end

def foo
  text = <<TEXT
Input two integers, and return the sum of them.<br>
<a href="test">test</a><br>
test<br>
test
TEXT
  make_prob({"prob_num" => 1,
              "title" => "Add two integers",
              "text" => text,
              "inputs" => ["1 2", "4 5", "99 9"],
              "outputs" => ["3", "9", "108"],
              "time_limit" => "1"})
  for i in 2..5
    make_prob({"prob_num" => i,
                "title" => "prob" + i.to_s,
                "text" => "This is the text for problem " + i.to_s + ".",})
  end
end

foo
