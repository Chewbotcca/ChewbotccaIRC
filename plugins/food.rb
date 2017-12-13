class Food
  include Cinch::Plugin

  match /taco (.+)/, method: :taco
  match /cookie (.+)/, method: :cookie
  match /potato (.+)/, method: :potato
  match /cake (.+)/, method: :cake
  match /biscuit (.+)/, method: :biscuit
  match /sandwich (.+)/, method: :sandwich
  match /fortune/, method: :fortune

  def fortune(m)
    fortunes = [
      "Help! I'm stuck in the fortune cookie factory!",
      'He who laughs at himself never runs out of things to laugh at.',
      'The world is your oyster.',
      'Today will be a good day.',
      'Haters gonna hate.',
      'You are amazing and let no one tell you otherwise.',
      'A starship ride has been promised to you by the galactic wizard.',
      'That wasn’t chicken.',
      'You will become a hermit and be sad and lonely for the rest of your life.',
      'The road to riches is paved with homework.',
      'Take calculated risks. That is quite different from being rash.',
      'DO THE IMPOSSIBLE, SEE THE INVISIBLE.',
      'You cannot plough a field by turning it over in your mind. Unless you have telekinesis.',
      'No one can make you feel inferior without your consent.',
      'Never lose the ability to find beauty in ordinary things.',
      'Ignore previous fortune.',
      'Smile more.',
      "YOU'RE THE BEST AROUND, NOTHIN'S GONNA EVER KEEP YA DOWN.",
      'The cake is not a lie.',
      'Never take life seriously. Nobody gets out alive anyway.',
      'Friendship is like peeing on yourself: everyone can see it, but only you get the warm feeling that it brings.',
      'Never go to a doctor whose office plants have died.',
      "Always remember you're unique, just like everyone else.",
      'What if everything is an illusion and nothing exists? (In that case, I definitely overpaid for my carpet)',
      'Don’t be discouraged, because every wrong attempt discarded is another step forward.',
      'Even if you are on the right track, you will get run over if you just sit there.',
      'Think like a man of action, and act like a man of thought.',
      'It is time for you to live up to your family name and face FULL LIFE CONSEQUENCES.',
      "It's a good day to do what has to be done.",
      'Move near the countryside and you will be friends of John Freeman.',
      "If you can't beat 'em, mock 'em.",
      "Use gun. And if that don't work, use more gun.",
      'LOOK OUT BEHIND YOU',
      'You will die, but become reanimated as a Zombie, and forever roam the earth in search of purpose... And brains, of course.',
      'This message will self destruct in 10 seconds.',
      'You will live a normal life, with a normal home, a normal job, and a normal future.',
      "You'll never know what you can do until you try.",
      'A person of words and not deeds is like a garden full of weeds.',
      'You are talented in many ways',
      'Be both a speaker of words and a doer of deeds.',
      'A visit to a strange place will bring you renewed perspective.',
      'A passionate new romance will appear in your life when you least expect it.',
      'If you care enough for a result, you will most certainly attain it.',
      'To be loved, be loveable.',
      'Step away from the power position for one day.',
      'If you want to get a sure crop with a big yield, sow wild oats.',
      "It doesn't take guts to quit.",
      'You can expect a change for the better in job or status in the future.',
      'As the wallet grows, so do the needs.',
      'You have a reputation for being straightforward and honest.',
      'Learn a new language and get a new soul.',
      'A dubious friend may be an enemy in camouflage.',
      'A tall dark stranger will soon enter your life.',
      "Keep staring. I'll do a trick."
    ]
    m.reply "#{m.user} opens a fortune cookie, it reads: #{fortunes.sample}"
  end

  def taco(m, user)
    toppings = ['guacamole', 'salsa', 'sour cream', 'cheese', 'lettuce', 'tomatoes', 'avocado', 'onion', 'scallions', 'jalepeños', 'capsicum', 'ghost chili', 'olives', 'pineapple', 'raspberries']
    tacotype = %w[spicy mild tasty delicious boring disgusting perfect]
    meat = ['minced beef', 'shredded beef', 'steak', 'pork', 'various meats', 'chicken', 'refried beans', 'tofu']
    m.reply "#{m.user.nick} gives #{user} a #{tacotype.sample} taco filled with #{meat.sample} with #{toppings.sample}, #{toppings.sample}, and #{toppings.sample}!"
  end

  def cookie(m, user)
    cookies = ['Chocolate Chip', 'Oatmeal', 'Sugar', 'Oatmeal Raisin', 'Macadamia Nut', 'Jam Thumbprint', 'Medican Wedding', 'Biscotti', 'Oatmeal Cranberry', 'Chocolate Fudge', 'Peanut Butter', 'Pumpkin', 'Lemon Bar', 'Chocolate Oatmeal Fudge', 'Toffee Peanut', 'Danish Sugar', 'Triple Chocolate', 'Oreo']
    size = ['small', 'little', 'medium-sized', 'large', 'gigantic']
    flavour = %w[tasty delectable delicious yummy toothsome scrumptious luscious]
    methods = %w[makes gives gets buys]
    side_dish = ['glass of milk', 'bowl of ice cream', 'bowl of chocolate sauce']
    m.reply "#{m.user.nick} #{methods.sample} #{user} a #{flavour.sample} #{size.sample} #{cookies.sample} cookie and serves it with a #{side_dish.sample}"
  end

  def potato(m, user)
    potatoes = ['Laura', 'Kind Edward', 'Kerr\'s Pink', 'Sweet', 'Normal']
    size = ['small', 'little', 'mid-sized', 'medium-sized', 'large', 'gigantic']
    flavour = %w[tasty delectable delicious yummy toothsome scrumptious luscious]
    method = %w[bakes fries boils roasts]
    side_dish = ['side joey', 'dollop of sour cream', 'piece of chicken', 'bowl of shredded bacon']
    m.reply "#{m.user.nick} #{method.sample} a #{flavour.sample} #{size.sample} #{potatoes.sample} potato for #{user} and serves it with a small #{side_dish.sample}"
  end

  def cake(m, user)
    cakes = ['Chocolate', 'Ice Cream', 'Angel', 'Boston Cream', 'Birthday', 'Bundt', 'Carrot', 'Coffee', 'Devils', 'Fruit', 'Gingerbread', 'Pound', 'Red Velvet', 'Stack', 'Welsh', 'Yokan']
    size = ['small', 'little', 'mid-sized', 'medium-sized', 'large', 'gigantic']
    flavour = %w[tasty delectable delicious yummy toothsome scrumptious luscious]
    method = %w[makes gives gets buys]
    side_dish = ['glass of chocolate milk', 'bowl of ice cream', 'jar of cookies', 'some chocolate sauce']
    m.reply "#{m.user.nick} #{method.sample} #{user} a #{flavour.sample} #{size.sample} #{cakes.sample} cake and serves it with a small #{side_dish.sample}"
  end

  def biscuit(m, user)
    biscuits = ['Digestive', 'Caramel', 'Hobnob', 'Rich Tea', 'Custard Cream', 'Chocolate Finger', 'Ginger Nut', 'Penguin Bar', 'Fruit Shortcake', 'Caramel Wafer', 'Shortbread Round', 'Lemon Puff', 'Elite Chocolate Tea Cake', 'Club Bar', 'Viennese', 'Bourbon Cream', 'Malted Milk', 'Lotus Biscoff', 'Fig Roll', 'Jammie Dodger', 'Oatie', 'Jaffa Cake']
    flavour = ['tasty', 'delectable', 'delicious', 'yummy', 'gorgeous', 'scrumptious', 'luscious', 'irresistible', 'mouth watering']
    method = ['makes', 'gives', 'gets', 'buys', 'unwantingly passes', 'grants', 'force feeds']
    m.reply "#{m.user.nick} #{method.sample} #{user} a #{flavour.sample} #{biscuits.sample} biscuit."
  end

  def sandwich(m, user)
    meat = ['ham', 'salami', 'steak', 'meatball', 'tuna', 'pork', 'chicken', 'roast beef', 'corned beef', 'pastrami', 'turkey']
    flavour = ['a tasty', 'a delicious', 'an awesome', 'an excellent', 'a beautifully-made']
    type = %w[roll wrap pita sandwich bun]
    method = %w[hands gives makes passes]
    joey = ['tomatoes', 'lettuce', 'pickles', 'cucumbers', 'red onions', 'jalapenos', 'banana peppers', 'spinach', 'avocado', 'sprouts']
    sauce = ['sweet onion sauce', 'honey mustard sauce', 'mayo', 'sweet chili sauce', 'italian sauce', 'ranch dressing', 'barbecue sauce']
    andmeat = [" and #{meat.sample}", '']
    templates = [" and #{sauce.sample}!", ", #{joey.sample}, and #{sauce.sample}!", ", #{joey.sample}, #{joey.sample}, and #{sauce.sample}!"]
    m.reply "#{m.user.nick} #{method.sample} #{user} #{flavour.sample} #{meat.sample}#{andmeat.sample} #{type.sample} with #{joey.sample}#{templates.sample}"
  end
end
