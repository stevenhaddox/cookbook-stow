module StowCookbook
  # Utility methods for the Stow cookbook
  module Utils
    # Simplify variable existence checks with .blank?
    def blank?(object)
      object.nil? || object.empty?
    end
  end
end
