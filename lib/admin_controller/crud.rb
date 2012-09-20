# Common pattern for the admin of data.
module AdminController::Crud
  extend ActiveSupport::Concern

  included do
    self.responder = AdminController::Responder
    respond_to :html
  end

  def index
    load_objects
    respond_with controller_namespace + [@objects]
  end

  def new
    new_object
    respond_with_object
  end

  def create
    new_object
    save
  end

  def edit
    load_object
    respond_with_object
  end

  def update
    load_object
    save
  end

  def destroy
    load_object
    @object.destroy
    respond_with_object 
  end

  # So the view can generically know where to go
  def resource_location
    responder.send :resource_location
  end

  protected

  def responder
    self.class.responder.new self, controller_namespace + (@objects || [@object])
  end

  # Create a new instance of the object we are editing populated with
  # any params from the form params.
  def new_object
    @object = klass.new params[object_name.to_sym]
    set_instance
  end

  # Will load an existing object updated the attributes from the params
  def load_object
    @object = scope.find params[:id]
    @object.attributes = params[object_name.to_sym]
    set_instance
  end

  # Populate a new or existing object ot a familiar variable name
  def set_instance
    instance_variable_set "@#{object_name}", @object
  end

  # Pull all objects being edited and place in familiar variable name
  def load_objects
    @objects = scope.all
    instance_variable_set "@#{object_name.pluralize}", @objects
  end

  # The scope to limit objects with
  def scope
    klass
  end

  # The class of the model we are pulling
  def klass
    object_name.classify.constantize
  end

  # The thing we are editing. Based on the controller name
  def object_name
    self.class.name.underscore.split('/').last.sub(/_controller$/, '').singularize
  end

  def controller_namespace
    self.class.name.underscore.split('/')[0..-2].collect &:to_sym
  end

  # Not really for overriding. Just grouping common behavior
  private

  def save
    @object.save
    respond_with_object
  end

  # If we are namespaced then we need to respond with the namespace
  # as the prefix. I.E. [admin, @foo]. But if we are not namespaced then
  # we just need the object. I.E. @foo
  def respond_with_object
    resource = controller_namespace + [@object]
    respond_with *resource
  end

end
