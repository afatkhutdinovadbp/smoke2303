# frozen_string_literal: true
# encoding: utf-8

def reverse_words(str)
  str.split.map(&:reverse).join(' ')
end

if __FILE__ == $PROGRAM_NAME
  input = ARGV.join(' ')
  puts reverse_words(input)
end
