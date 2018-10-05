FactoryBot.define do
  factory :note do
    title "Example"
    content "TODO"
    author_id 7
    project_id 1
    actable_type 'Note'
  end
end
