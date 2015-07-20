actions :stow, :destow
default_action :stow

attribute :name, kind_of: String, required: true, name_attribute: true
attribute :version, kind_of: String, required: true
attribute :creates, kind_of: String, required: true
attribute :destow_existing, kind_of: [TrueClass, FalseClass], required: false,
                            default: true
attribute :current_version, kind_of: [String, NilClass], required: false,
                            default: nil
