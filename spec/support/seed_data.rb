# seed_data.rb
def create_users
  user = User.create!({
    first_name: 'John',
    last_name: 'Doe',
    email: 'johndoe@gmail.com',
    password: 123123
  })
  user
end

