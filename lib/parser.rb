require 'json'

class Parser

  def initialize body:
    @body = JSON.parse(body)
  end

  def width
    @body["board"]["width"]
  end

  def height
    @body["board"]["height"]
  end

  def you
    @body["you"]["id"]
  end

  def food
    @body["board"]["food"]
  end

  def snakes
    @body["board"]["snakes"]
  end

  def snake snake_resp
    snake_resp["body"].uniq
  end
end
