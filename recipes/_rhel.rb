include_recipe 'yum-epel'

potentially_at_compile_time do
  package 'stow'
end
