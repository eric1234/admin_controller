class AdminController::Responder < ActionController::Responder
  include Responders::CollectionResponder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # If edit or new then render the default_action which is not set to
  # form instead of rendering based on action name.
  def default_render
    render :action => default_action and return if
      %w(edit new).include? controller.action_name
    super
  end

  # Override to use common form template instead of per-action template.
  # Used by above overridden default_render and by the default responder
  # when an error occurs
  def default_action
    'form'
  end

  # Extend to allow the controller to override this.
  def navigation_location
    location = controller.send :navigation_location if
      controller.respond_to? :navigation_location
    location || super
  end
end

