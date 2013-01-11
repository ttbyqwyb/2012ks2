#!/usr/bin/ruby

class Execution
  def initialize(args)
    @args = args
  end
  
  def run()
    system_error = { 'verdict' => 'System Error' }
    compile_error = { 'verdict' => 'Compile Error' }
    
    time_limit = @args['time_limit']
    input_dir = @args['input_dir']
    output_dir = @args['output_dir']
    test_files = @args['test_files']
    
    source_file = @args['source_file']
    language = @args['language']
    
    //  TODO
    user_name = 'user_name'
    test_dir = 'test_dir'
    
    return system_error if 0 != system("mkdir #{test_dir}")
    return system_error if 0 != system("sudo useradd #{user_name}")
    return system_error if 0 != system("sudo chown #{user_name}:#{user_name} #{test_dir}")
    
    case language
    when "C++"
      return compile_error if 0 != system("g++ -O2 #{source_file} -o #{test_dir}/a")
      execution_cmd = '#{test_dir}/a'
    when "Ruby"
      return system_error if 0 != system("cp #{source_file} #{test_dir}/a.rb")
      execution_cmd = 'ruby #{test_dir}/a.rb'
    else
      return system_error
    end
    
    verdict = 'Accepted'
    test_files.each do |test|
      return system_error if 0 != system("cp #{input_dir}/#{test} input")
      res = system("sudo -u #{user_name} timeout #{time_limit} #{execution_cmd} < input > output")
      if res != 0
        verdict = 'Runtime Error'
        break
      end
      res = system("diff output #{output_dir}/#{test}")
      if res != 0
        verdict = 'Wrong Answer'
        break
      end
    end
    
    return system_error if 0 != system("rm -f #{test_dir}")
    return system_error if 0 != system("sudo userdel #{user_name}")
    
    return { 'verdict' => verdict }
  end
end


