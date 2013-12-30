require "sequel"

a = Sequel.sqlite("mydb.db")
# a.create_table :tickets do
#   primary_key :id
#   String :event
#   Float :ntickets
#   Float :pricept
# end

b = a[:tickets]
# b.insert(:event => "Jukebox War!", :ntickets => 100, :pricept => 12)
# b.insert(:event => "Jukebox War2!", :ntickets => 200, :pricept => 22)
# b.insert(:event => "Jukebox War3!", :ntickets => 300, :pricept => 32)
# b.insert(:event => "Jukebox War4!", :ntickets => 400, :pricept => 42)
# 40.times do |i|
  b.where{id > 0}.delete
