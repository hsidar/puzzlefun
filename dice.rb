class DiceGame
  
  require 'pry'
  
  # Start the game, display the rules, and initialize instance variables
  
  def play
    
    puts '

Rules:

Player starts with 25$.

Player must bet on whether roll will "PASS" or "CRAP".

"PASS" on first roll must roll 7 or 11.

"CRAP" is a 2, 3, or 12 on the first roll.

The "POINT" is any value between 4 and 10 rolled on the first roll.

If pass or crap is not reached on first roll, the player must continue rolling until either the point or 7 is reached. 

All bets that the shooter would "pass" are now bets that the shooter will re-roll the value of the point before rolling a 7.

All bets that the shooter would "crap" are bets that 7 will be rolled first.

First roll resolution makes people happy. Constant rerolls make people hostile and can lead to choreographed dance-offs, knife fights, and hurt feelings.

If player gets to 100$, then they win.

'
    
    @money = 25
    @hostility = 10
    @first_turn_flag = true
    @point = 0
    @bet = 0
    @choice = ""
    
    take_bet
    
  end
  
  # Take initial bet on "Come out" roll

  def take_bet
    
    puts "
What's it gonna be? Pass or Crap?" if @choice == ""
    @choice = test_choice if @choice == ""

    puts "
How much you wanna put on it? Remaining funds $#{@money}" if @bet == 0
    @bet = test_bet if @bet == 0

    roll_dice
  
  end
  
  # Get and test customer choice.
  
  def test_choice
    
    @choice = gets.chomp.downcase
    
    if @choice[0] == "p"
      return "pass"
    elsif @choice[0] == "c"
      return "crap"
    else
      puts "
That isn't a choice ... try again."
      @choice = ""
      take_bet
    end
    
  end
    
  # Get and test bet
  
  def test_bet
    
    @bet = gets.chomp.tr('$', '').to_i
    
    if @bet <= 0
      puts "
That isn't any kind of bet. You gotta pay to play!"
      take_bet
    elsif @bet > @money
      puts "
You must be trying to hustle me. You don't have that kind of money! Make a real bet."
      @bet = 0
      take_bet
    else
      @money -= @bet
      return @bet
    end
    
  end
  
  # Roll the dice, return the outcome

  def roll_dice
    
    dice_array = []
    2.times do |x|
      dice_array[x] = rand(1..6)
    end
    process_results(dice_array)
    
  end

  # Process results, adding dice rolls together, handling the outcome, and changing the first_turn_flag if needed.

  def process_results(results)
    
    number = results[0] + results[1]
    
    preface = "#{results[0]} and #{results[1]}. That's #{number}"
    postface = "\nPress Enter to Continue"
    
  if @first_turn_flag == true
      case number
        when 7, 11
          puts "
#{preface}. BOOM. Pass on the first try!!#{postface}"
          @hostility = 10
          gets
          ante_up("pass")
        when 2, 3, 12
          puts "
#{preface}!! The roll crapped out!#{postface}"
          @hostility = 10
          gets
          ante_up("crap")
        when 4..10
          puts "
#{preface}. Looks like a Point game! The point is #{number}. Play through.#{postface}"
          gets
          @point = number
          @first_turn_flag = false
          roll_dice
      end
    else
      case number
        when @point
          puts "
#{preface}!! The Point was hit! Time to ante up!#{postface}"
          gets
          ante_up("pass")
        when 7
          puts "
#{preface}! Looks like the craps have it.#{postface}"
          gets
          ante_up("crap")
        else
          puts "
#{preface}! ... Doesn't mean anything. Rollin' on!#{postface}"
          @hostility -= 1 if @hostility >=1
          gets
          roll_dice
      end 
    end
  end
  
  # change money amount based on bet
  
  def ante_up(decision)
    
    if @choice == "pass"
      if decision == "pass"
        @money += @bet * 2
        puts "
PASS!! YOU WON $#{@bet}"
      else
        puts "
CRAP!! YOU LOST $#{@bet}"
      end
    elsif decision == "crap"
        @money += @bet * 2
        puts "
CRAP!! YOU WON $#{@bet}"
    else
        puts "
PASS!! YOU LOST $#{@bet}"
    end
    
    game_over?
    
  end
  
  def game_over?
    
    knives = rand(@hostility)
    
    if @money <= 0
      puts "

YOU ARE BROKE AS HELL. WALK AWAY.

"
      exit
    elsif @money >= 100
      puts "

YOU HAVE ALL THE MONEY. GOOD LUCK GETTING HOME SAFELY.

"
      exit
    elsif knives == rand(@hostility)
      puts "

A KNIFE FIGHT BROKE OUT. YOU HAVE BEEN STABBED AND ROBBED. GOOD DAY.

"
      exit
    else
      continue_playing?
    end
  end

  def continue_playing?
    
    puts "
Keep playing? y/n (Remaining funds $#{@money})"
    continue = gets.chomp
    
    if continue == "y"
      
    @first_turn_flag = true
    @point = 0
    @bet = 0
    @choice = ""
    
    take_bet
      
    elsif continue == "n"
      
      puts "

YOU WALK AWAY WITH $#{@money} HAVING NOT SEEN YOUR QUEST THROUGH TO IT'S INEVITABLY BITTER END."
      exit
      
    else
      
    puts "
That isn't a choice."
    continue_playing?
      
    end  
  end

end


dice = DiceGame.new

dice.play

