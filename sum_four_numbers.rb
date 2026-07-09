#!/usr/bin/env ruby
# frozen_string_literal: true

# Sums four numbers from command-line arguments or interactive input.

def sum_four(a, b, c, d)
  a + b + c + d
end

numbers =
  if ARGV.length >= 4
    ARGV.take(4).map(&:to_f)
    puts "ARGV: #{ARGV}"
    puts "ARGV.take(4): #{ARGV.take(4)}"
    puts "ARGV.take(4).map(&:to_f): #{ARGV.take(4).map(&:to_f)}"
  else
    puts "Enter four numbers (one per line):"
    4.times.map { gets.to_f }
  end

result = sum_four(*numbers)
puts "Sum: #{result}"
