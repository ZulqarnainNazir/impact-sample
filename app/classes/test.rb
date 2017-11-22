begin
  puts 'hi'
  body = "Another’s Example"
  puts 'hi2'
  body.encode!('utf-8', invalid: :replace, undef: :replace, replace: '_')
  puts body
rescue ex
  puts ex.message
end
