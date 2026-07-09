# frozen_string_literal: true
# encoding: utf-8

VOWELS = /[аеёиоуыэюяaeiouyАЕЁИОУЫЭЮЯAEIOUY]/

def sum(a, b)
  a + b
end

def extract_vowels(str)
  str.scan(VOWELS).join
end

if __FILE__ == $PROGRAM_NAME
  a = ARGV[0].to_f
  b = ARGV[1].to_f
  puts sum(a, b)
end


