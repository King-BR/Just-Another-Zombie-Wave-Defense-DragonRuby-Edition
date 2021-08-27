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
    dis = @args.geometry.distance [@x, @y], [player_x, player_y];

    if (dis > @entity_size) 

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
    # Debug sprite position
    #@args.outputs.solids << [@x - @entity_size/2, @y - @entity_size/2, @entity_size, @entity_size, *@args.state.colors.GREEN];
    #@args.outputs.solids << [@x, @y, 1, 1, *@args.state.colors.RED];
    
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
      #@args.geometry.distance [@player_x, @player_y],
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
    #@args.outputs.solids << [@player_x - @entity_size/2, @player_y - @entity_size/2, @entity_size, @entity_size, 0, 0, 255, 255];
    #@args.outputs.solids << [@player_x, @player_y, 1, 1, 255, 0, 0, 255];

    @args.outputs.sprites << {
      x: @player_x - @entity_size/2,
      y: @player_y - @entity_size/2, 
      w: @entity_size, 
      h: @entity_size, 
      path: 'sprites/circle/blue.png'
    };
    
    r, g, b, a = @args.state.colors.RED
    @args.outputs.labels << {
      x: @player_x - 12 - @entity_size/2,
      y: @player_y - 5 - @entity_size/2,
      text: "#{@player_hp}/#{@player_maxhp}",
      r: r,
      g: g,
      b: b,
      a: a
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

  args.state.colors = {
    RED: [255, 0, 0, 255],
    GREEN: [0, 255, 0, 255],
    BLUE: [0, 0, 255, 255],
    CYAN: [0, 255, 255, 255],
    PINK: [255, 0, 255, 255],
    YELLOW: [255, 255, 0, 255],
    ORANGE: [255, 150, 0, 255],
    BLACK: [0, 0, 0, 255],
    WHITE: [255, 255, 255, 255],
    GRAY: [128, 128, 128, 255],
    DARK_GRAY: [90, 90, 90, 255],
    LIGHT_GRAY: [190, 190, 190, 255]
  };
  

  args.state.entity_size ||= 40;
  args.state.game ||= Game.new args;
  args.state.game.tick;
end