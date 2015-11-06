def error
 raise "Here"
end

def run
  error
 rescue => e
   puts e.backtrace
   puts e.message
end

run
