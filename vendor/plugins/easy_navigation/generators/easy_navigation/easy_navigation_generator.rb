class EasyNavigationGenerator < Rails::Generator::Base
  attr_accessor :controllers
  def manifest

    record do |m|

      # CSS rules for EasyNavigation
      m.directory("public/stylesheets/sass")
      m.file "stylesheets/sass/easy_navigation.sass", "public/stylesheets/sass/easy_navigation.sass"

      # Javascript for horizontal dropdown menu's
      m.directory("public/javascripts")
      m.file "javascripts/easy_navigation.js", "public/javascripts/easy_navigation.js"

      m.directory("public/images/easy_navigation")
      m.file "images/arrow.png", "public/images/arrow.png"

    end
  end

  protected

    def extract_routes

      self.controllers = {}

      ActionController::Routing::Routes.routes.each do |route|

        if route.parameter_shell.has_key?(:controller)

          unless self.controllers.has_key?(route.parameter_shell[:controller])
            self.controllers[route.parameter_shell[:controller]] = { :actions => [] }
          end

          unless self.controllers[route.parameter_shell[:controller]].include? route.parameter_shell[:action]
            self.controllers[route.parameter_shell[:controller]][:actions] << route.parameter_shell[:action]
          end

        end
      end

    end

    def build_easy_navigation_configuration
      extract_routes
      self.controllers.keys.sort.each do |controller_name|
        self.controllers[controller_name][:actions].each do |action_name|
          p "#{controller_name} => #{action_name}"
        end
      end
    end

end
