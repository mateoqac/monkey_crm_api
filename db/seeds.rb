puts 'Cleaning the database...'
User.destroy_all
Role.destroy_all

puts 'Creating roles...'
%w[admin superadmin].each do |role_name|
  Role.create!(name: role_name)
end

puts 'Creating users...'

3.times do |i|
  User.create!(
    name: "name_#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: 'password123',
    password_confirmation: 'password123'
  )
end

2.times do |i|
  user = User.create!(
    name: "name_admin_#{i + 1}",
    email: "admin#{i + 1}@example.com",
    password: 'adminpass123',
    password_confirmation: 'adminpass123'
  )
  user.add_role(:admin)
end

superadmin = User.create!(
  name: 'name_superadmin',
  email: 'superadmin@example.com',
  password: 'superadminpass123',
  password_confirmation: 'superadminpass123'
)
superadmin.add_role(:superadmin)

puts 'Seeding completed successfully!'
puts "Created #{User.count} users:"
puts "- Admin users: #{User.with_role(:admin).count}"
puts "- Superadmin users: #{User.with_role(:superadmin).count}"
