Fabricator(:user) do
  email                 { Faker::Internet.email }
  username              { Faker::Internet.user_name }
  password              "ala123"
  password_confirmation "ala123"
end
