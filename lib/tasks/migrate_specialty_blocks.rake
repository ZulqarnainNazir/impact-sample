desc 'Migrate Specialty Blocks'
task migrate_specialty_blocks: [:environment] do
  Group.where(type: 'SpecialtyGroup').update_all(type: 'ContentGroup')
  Block.where(type: 'SpecialtyBlock', theme: 'right').update_all(type: 'ContentBlock', theme: 'right_half')
  Block.where(type: 'SpecialtyBlock').update_all(type: 'ContentBlock', theme: 'left_half')
end
