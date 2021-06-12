# frozen_string_literal: true

class FindProfessionalsService
  def initialize(current_user)
    @current_user = current_user
  end

  def execute
    professionals = User.not_current(@current_user.id).with_role(:agent).limit(5)
    ActiveModelSerializers::SerializableResource.new(professionals,
                                                     each_serializer: UsersSerializer,
                                                     scope: @current_user).as_json
  end
end
