# A happy number is a number defined by the following process: Starting with any positive integer, replace the number by the sum of the squares of its digits, and repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1. Those numbers for which this process ends in 1 are happy numbers, while those that do not end in 1 are unhappy numbers (or sad numbers).

# global variable to store results in for comparison.

@history = []

# Prep number: Create array to test against. Test if number is single digit.

def prep_number(number)
  number_array = number.split('')
  number_array.unshift("0") if number.length == 1
  process_number(number_array, number)
end

# Process number: Square each number. Add the squares.

def process_number(number_array, number)
  square_array = []
  number_array.each { |digit| square_array.push(digit.to_i ** 2) }
#  result = square_array.map(&:to_i).reduce(:+)
  result = 0
  square_array.each { |digit| result += digit.to_i }
  test_result(result, number)
end

# Test result: Is number happy? Is number equal to original array? Is number sad?

def test_result(result, number)
  mood = ""
  if result == 1
    puts "Number is Happy."
  elsif result == number || @history.include?(result)
    puts "Number is sad."
  else
    @history.push(result)
    prep_number(result.to_s)
  end
end

# Prompt for number

p "What is your number?"

number = gets.chomp

prep_number(number)