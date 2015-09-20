Fabricator(:mongo_session) do
  name       { Faker::App.name.downcase }
  database   { Faker::App.name.downcase }
  hosts      ["192.1.1.30:4600", "192.1.1.32:4600"]
  username   { Faker::Internet.user_name }
  password   "ala123"
end
