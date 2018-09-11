begin
  body.encode!('utf-8', invalid: :replace, undef: :replace, replace: '_')
  puts body
rescue => ex
  puts ex.message
end
