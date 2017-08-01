FactoryGirl.define do
  factory :note do
    title "Example"
    description "Simple example"
    content "TODO"
    author_id 7
    project_id 1
  end
end
