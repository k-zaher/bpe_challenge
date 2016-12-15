# This file should contain all the record creation needed
# to seed the database with its default values.
# Regular Users Seed
puts "Seeding Test Data #{'*' * 100}"

3.times do
  user = User.new
  user.name = Faker::Name.name
  user.email = Faker::Internet.email
  user.password = 'test@1234'
  user.admin = false
  user.save!
  puts "Created regular user with email: #{user.email}"
end

# Admin User Seed

user = User.new
user.name = Faker::Name.name
user.email = 'admin@bpe.com'
user.password = 'admin@admin'
user.admin = true
user.save!
puts "Created Admin user with email: #{user.email}"

# Vechile state seed
State.create!(name: 'Designed')
State.create!(name: 'Assembled')
State.create!(name: 'Painted')
State.create!(name: 'Tested')

puts 'Created 4 initial states: [Designed, Assembled, Painted, Tested]'

#  Vechile Seed

VehicleBYModel = ['BMW 328i', 'Audi A5',
                  'Toyota Prius', 'Ford F150',
                  'Lincoln Navigator', 'Honda Accord'].freeze

10.times do
  vehicle = Vehicle.new
  vehicle.name = VehicleBYModel.sample
  vehicle.desc = Faker::Lorem.sentence(3)
  vehicle.save!
  puts "Created vehicle #{vehicle.name} with id: #{vehicle.id}"
end

puts "Seed Done #{'*' * 100}"
