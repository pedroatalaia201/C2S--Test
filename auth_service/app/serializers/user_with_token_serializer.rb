class UserWithTokenSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :token, :token_expire_in

  def initialize(object, options = {})
    super

    @token  = instance_options[:token]
    @exp_in = instance_options[:exp_in]
  end

  def token
    @token
  end

  def token_expire_in
    @exp_in
  end
end
