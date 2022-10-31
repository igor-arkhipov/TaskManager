FactoryBot.define do
  sequence :string, aliases: [:password, :avatar] do |n|
    "string#{n}"
  end

  sequence :first_name, [:Ivan, :Piotr, :Sergey, :Sanya, :Kirill].cycle

  sequence :last_name, [:Ivanov, :Piotrov, :Sergeev, :Kuznetcov].cycle

  sequence :email do |n|
    "stranger#{n}@example.xyz"
  end
end
