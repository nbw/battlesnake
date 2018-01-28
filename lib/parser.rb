require 'json'

class Parser

  def initialize body:
    @body = JSON.parse(body)
  end

  def width
    @body["width"]
  end

  def height
    @body["height"]
  end

  def you
    @body["you"]["id"]
  end

  def food
    @body["food"]["data"]
  end

  def snakes
    @body["snakes"]["data"]
  end

  def snake snake_resp
    snake_resp["body"]["data"].uniq
  end
end
