$gtk.reset

class Enemy
  def initialize args
    @args = args
    @x = 640;
    @y = 180;
    @hp = 100;
    @maxhp = 100;
    @entity_size = args.state.entity_size;
    @speed = 1;
  end

  def pursuePlayer player_x, player_y
    if !@args.geometry.point_inside_circle? [@x, @y], [player_x, @player_y], @entity_size
      if @x < player_x
        @x += @speed;
      elsif @x > player_x
        @x -= @speed;
      end

      if @y < player_y
        @y += @speed;
      elsif @y > player_y
        @y -= @speed;
      end
    end
  end

  def render
    @args.outputs.sprites << {
      x: @x - @entity_size/2,
      y: @y - @entity_size/2, 
      w: @entity_size, 
      h: @entity_size, 
      path: 'sprites/circle/green.png'
    };
  end

  def tick player_x, player_y
    pursuePlayer player_x, player_y;
    render;
  end
end


class Game
  def initialize args
    @args = args;
    @player_x = 640;
    @player_y = 360;
    @player_hp = 100;
    @player_maxhp = 100;
    @entity_size = args.state.entity_size;
    @enemies = []
  end

  def spawnEnemy
    @enemies.push(Enemy.new @args);
  end

  def handlePlayerMovement
    if @args.inputs.up
      @player_y += 5;
    end
    
    if @args.inputs.down
      @player_y -= 5;
    end
    
    if @args.inputs.left
      @player_x -= 5;
    end
    
    if @args.inputs.right
      @player_x += 5;
    end
  end

  def render_player
    @args.outputs.sprites << {
      x: @player_x - @entity_size/2,
      y: @player_y - @entity_size/2,
      w: @entity_size, 
      h: @entity_size,
      path: 'sprites/circle/blue.png'
    };
    
    @args.outputs.labels << {
      x: @player_x - 12 - @entity_size/2,
      y: @player_y - 5 - @entity_size/2,
      text: "#{@player_hp}/#{@player_maxhp}"
    };
  end

  def render
    render_player;
  end

  def tick
    if @args.inputs.keyboard.key_down.r 
      spawnEnemy
    end

    handlePlayerMovement;

    @enemies.each do | enemy |
      enemy.tick @player_x, @player_y;
    end

    render;
  end
end

def tick args
  $gtk.suppress_mailbox = false;

  args.state.entity_size ||= 40;
  args.state.game ||= Game.new args;
  args.state.game.tick;
end