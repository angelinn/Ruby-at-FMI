def move(snake, direction)
  moved_snake = grow(snake, direction)
  moved_snake.shift
  moved_snake
end

def grow(snake, direction)
  grown_snake = snake.dup
  grown_snake.push(new_position(grown_snake[-1], direction))
  grown_snake
end

def new_food(food, snake, dimension)
  (food_x, food_y) = snake[0]

  while snake.include? [food_x, food_y]
    food_x = rand(0..dimension[:width] - 1)
    food_y = rand(0..dimension[:height] - 1)
  end

  [food_x, food_y]
end

def obstacle_ahead?(snake, direction, dimensions)
  position_ahead = new_position(snake[-1], direction)
  snake.include? position_ahead or out_of_bounds?(position_ahead, dimensions)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
  obstacle_ahead?(move(snake, direction), direction, dimensions)
end

def out_of_bounds?(position, dimensions)
  position[0] < 0 or
  position[1] < 0 or
  position[0] >= dimensions[:width] or
  position[1] >= dimensions[:height]
end

def new_position(old_position, direction)
  [old_position[0] + direction[0], old_position[1] + direction[1]]
end
