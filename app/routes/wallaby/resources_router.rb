if Rails.env.development?
  # NOTE: Rails reload! will hit here
  Rails.logger.debug '--> [ Wallaby ] Ready to preload and clear cache on reload. <--'
  GC.start
  Rails.cache.delete_matched 'wallaby/*'

  # NOTE: we search for subclasses of Wallaby::ResourcesController and Wallaby::ResourceDecorator.
  # therefore, under development environment, we need to preload all classes under /app folder in main_app
  # using `require` is not working for preloading, we need to constantize the class names to make Rails reload classes properly
  Wallaby::ApplicationController

  def preload(file_pattern)
    Dir[ file_pattern ].each do |file_path|
      begin
        name = file_path[ %r(app/[^/]+/(.+)\.rb), 1 ].gsub('concerns/', '')
        name.classify.constantize
      rescue NameError, LoadError => e
        Rails.logger.debug "PRELOAD ERROR: #{ e.message }"
      end
    end
  end

  preload 'app/models/**.rb'
  preload 'app/**/*.rb'
end

class Wallaby::ResourcesRouter
  DEFAULT_CONTROLLER = Wallaby::ResourcesController

  def call(env)
    params          = env['action_dispatch.request.path_parameters']
    controller      = find_controller_by params[:resources]
    params[:action] = find_action_by params

    controller.action(params[:action]).call env
  rescue AbstractController::ActionNotFound, Wallaby::ModelNotFound => e
    params[:error] = e
    DEFAULT_CONTROLLER.action(:not_found).call env
  end

  private
  def find_controller_by(resources_name)
    model_class = Wallaby::Utils.to_model_class resources_name
    Wallaby::Map.controller_map[model_class] || DEFAULT_CONTROLLER
  end

  def find_action_by(params)
    (params.delete(:defaults) || params)[:action]
  end
end
