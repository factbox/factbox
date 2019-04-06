FactoryBot.define do
  factory :note do
    title { 'Sample note' }
    content { 'A note for testing...' }
    author_id { 7 }
    project_id { 1 }
    actable_type { 'Note' }
    last_version { true }
  end
end
