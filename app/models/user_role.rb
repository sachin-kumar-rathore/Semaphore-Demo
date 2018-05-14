class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :security_role

  scope :security_role_id, ->(security_role_id) { where('security_role_id = ?', security_role_id) }

  after_commit :delete_cache

  private

  def delete_cache
    $redis.del('user_roles')
  end
end
