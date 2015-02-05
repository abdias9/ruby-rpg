# encoding: utf-8

load 'action.rb'
load 'mod/Direction.rb'
load 'map.rb'

class MoveEvent < Action
	attr_accessor :event, :steps

	def initialize(handle, event, steps, direction, speed)
		super handle, nil
		@event = event
		@steps = steps
		@direction = direction
		@speed = speed
		prepare
	end

	def prepare
		@start_block_x = @event.x / Map::TILE_SIZE
		@start_block_y = @event.y / Map::TILE_SIZE

		case @direction
			when Direction::TOP
				@end_position = @event.y - (@steps * Map::TILE_SIZE)
			when Direction::BOT
				@end_position = @event.y + (@steps * Map::TILE_SIZE)
			when Direction::LEF
				@end_position = @event.x - (@steps * Map::TILE_SIZE)
			when Direction::RIG
				@end_position = @event.x + (@steps * Map::TILE_SIZE)
		end

		self.finished = false
	end

	def update
		super
		@event.state = State::MOV
		@event.direction = @direction

		puts "#{@event.x} -- #{@end_position}"

		case @direction
			when Direction::TOP
				if @event.y != @end_position
					@event.y -= @speed
				else 
					finish
				end
			when Direction::BOT
				if @event.y != @end_position
					@event.y += @speed
				else
					finish
				end
			when Direction::LEF
				if @event.x != @end_position
					@event.x -= @speed
				else
					finish
				end
			when Direction::RIG
				if @event.x != @end_position
					@event.x += @speed
				else
					finish
				end
			else 
				puts '[WARNING] Unknown Direction'
		end
	end

	def finish
		super
		@event.state = State::IDLE
	end
end