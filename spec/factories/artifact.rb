FactoryGirl.define do
  factory :note do
    title "Example"
    description "Simple example"
    # It's not possible create user, because user creates this project,
    # so just quote him. See /spec/factories/user.rb
    author_id 7
  end
end
