class ResponseFormatRepresenter
  def initialize(success:, code:, payload:, **options)
    @success, @code, @payload, @options = success, code, payload, options
  end

  def send
    options.merge({
      success: success,
      code: code,
      payload: payload
    }).as_json
  end
  

  private attr_reader :success, :code, :payload, :options
end