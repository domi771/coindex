class DepositGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :code, :type => :string
  argument :symbol, :type => :string, :default => '#'

  def copy_initializer_file
    template "model.rb.erb", "app/models/deposits/#{name.underscore}.rb"
    template "controller.rb.erb", "app/controllers/private/deposits/#{name.underscore.pluralize}_controller.rb"
    template "locales/de.yml.erb", "config/locales/deposits/#{name.underscore.pluralize}/de.yml"
    template "locales/en.yml.erb", "config/locales/deposits/#{name.underscore.pluralize}/en.yml"
    template "views/new.html.slim.erb", "app/views/private/deposits/#{name.underscore.pluralize}/new.slim"
    template "views/admin/index.html.slim.erb", "app/views/admin/deposits/#{name.underscore.pluralize}/index.html.slim"
    template "admin_controller.rb.erb", "app/controllers/admin/deposits/#{name.underscore.pluralize}_controller.rb"
  end
end
