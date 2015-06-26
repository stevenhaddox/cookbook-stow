potentially_at_compile_time do
  remote_file "#{node['stow']['path']}/stow-2.2.0.tar.gz" do
    source node['stow']['src_url']
  end
end
