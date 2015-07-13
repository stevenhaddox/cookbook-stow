module StowCookbook
  # Utility methods for the Stow cookbook
  module Utils
    include Chef::DSL::IncludeRecipe

    # Simplify variable existence checks with .blank?
    def blank?
      self.nil? || self.empty?
    end
  end
end
