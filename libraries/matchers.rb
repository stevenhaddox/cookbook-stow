if defined?(ChefSpec)
  def stow_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :stow_package, :stow, resource_name
    )
  end

  def destow_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :stow_package, :destow, resource_name
    )
  end
end
