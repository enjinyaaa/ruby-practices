def fizzbuzz(cntnum, num1, num2)
  cntnum.times do |i|
    num = i + 1
    if num % num1 == 0 && num % num2 == 0
      puts "FizzBuzz"
    elsif num % num1 == 0
      puts "Fizz"
    elsif num % num2 == 0
      puts "Buzz"
    else
      puts num
    end
  end
end

fizzbuzz(20, 3, 5)
