# frozen_string_literal: true

class FindPosibleUserMatchesService
  def initialize(user_id)
    @user_id = user_id
  end

  def execute
    User.where(id: user_ids)
  end

  private

  def user
    @user ||= User.find(@user_id)
  end

  def user_ids
    query = <<~SQL
      SELECT user_id
        FROM
        ( SELECT live_factor_id, response + 1 as hight, response - 1 as low
          FROM responses
          WHERE user_id = #{user.id}
        ) as user_responses, responses
        WHERE user_id != #{user.id}
        AND response BETWEEN user_responses.low AND user_responses.hight AND user_responses.live_factor_id = responses.live_factor_id
        GROUP BY user_id
      HAVING COUNT(user_id) = #{LiveFactor.all.count};
    SQL
    response = Response.connection.exec_query(query)
    response.rows.flatten
  end
end
