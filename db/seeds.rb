# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clear existing users
User.destroy_all

# Create client users
clients = [
  {
    email: 'client1@example.com',
    password: 'password123',
    name: 'John Smith',
    role: 'client'
  },
  {
    email: 'client2@example.com',
    password: 'password123',
    name: 'Sarah Johnson',
    role: 'client'
  }
]

# Create worker users
workers = [
  {
    email: 'worker1@example.com',
    password: 'password123',
    name: 'Michael Brown',
    role: 'worker'
  },
  {
    email: 'worker2@example.com',
    password: 'password123',
    name: 'Emily Davis',
    role: 'worker'
  }
]

# Create all users
(clients + workers).each do |user_data|
  User.create!(user_data)
end

puts "Created #{User.count} users:"
puts "- #{User.where(role: 'client').count} clients"
puts "- #{User.where(role: 'worker').count} workers"
