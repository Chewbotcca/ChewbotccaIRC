class Food
  include Cinch::Plugin

  match /taco (.+)/, method: :taco
  match /cookie (.+)/, method: :cookie
  match /potato (.+)/, method: :potato
  match /cake (.+)/, method: :cake
  match /biscuit (.+)/, method: :biscuit
  match /sandwich (.+)/, method: :sandwich

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
