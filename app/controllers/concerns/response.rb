module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm}")

    render json: 'Bad credentials', status: :unauthorized
  end
end