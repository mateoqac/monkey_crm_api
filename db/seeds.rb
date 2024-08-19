# frozen_string_literal: true

Rails.logger.debug 'Cleaning the database...'
User.destroy_all
Role.destroy_all

Rails.logger.debug 'Creating roles...'
%w[admin superadmin].each do |role_name|
  Role.create!(name: role_name)
end

Rails.logger.debug 'Creating users...'

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

Rails.logger.debug 'Seeding completed successfully!'
Rails.logger.debug { "Created #{User.count} users:" }
Rails.logger.debug { "- Admin users: #{User.with_role(:admin).count}" }
Rails.logger.debug { "- Superadmin users: #{User.with_role(:superadmin).count}" }
