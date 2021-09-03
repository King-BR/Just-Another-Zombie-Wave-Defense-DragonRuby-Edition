$gtk.reset

def handlePlayerMovement args
  if args.inputs.up
    args.state.player_y += 5;
  end
  
  if args.inputs.down
    args.state.player_y -= 5;
  end
  
  if args.inputs.left
    args.state.player_x -= 5;
  end
  
  if args.inputs.right
    args.state.player_x += 5;
  end
end

def render_player args
  args.outputs.sprites << {
    x: args.state.player_x - args.state.entity_size/2,
    y: args.state.player_y - args.state.entity_size/2, 
    w: args.state.entity_size, 
    h: args.state.entity_size, 
    path: 'sprites/circle/blue.png'
  };
  
  r, g, b, a = args.state.colors.RED
  args.outputs.labels << {
    x: args.state.player_x - 12 - args.state.entity_size/2,
    y: args.state.player_y - 5 - args.state.entity_size/2,
    text: "#{args.state.player_hp}/#{args.state.player_maxhp}",
    r: r,
    g: g,
    b: b,
    a: a
  };
end

def render_bullets args
  args.outputs.solids << args.state.bullets.map(&:rect)
end

def render_zombies args
  args.outputs.sprites << args.state.enemies.map(&:rect);

  args.outputs.labels  << args.state.enemies.flat_map do |enemy|
    [
      [enemy.x + 4, enemy.y + 29, "id: #{enemy.entity_id}", -3, 0],
      [enemy.x + 4, enemy.y + 17, "created_at: #{enemy.created_at}", -3, 0] # frame enemy was created
    ];
  end
end

def render args
  render_player args;
  render_bullets args;
  render_zombies args;
end

def tick args
  args.state.colors ||= {
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
  
  # Player vars
  args.state.player_x ||= 640;
  args.state.player_y ||= 360;
  args.state.player_hp ||= 100;
  args.state.player_maxhp ||= 100;
  args.state.player_ammo ||= 30;
  args.state.bullets ||= [];

  # Buildings vars
  args.state.buildings ||= [];
  
  # Zombies vars
  args.state.zombie_base_dmg ||= 10;
  args.state.enemies ||= [];

  # Common vars
  args.state.entity_size ||= 40;
  args.state.base_speed ||= 1;

  # Drop chances
  args.state.ammo_drop ||= 0.2;
  args.state.hp_drop ||= 0.2;
  args.state.boost_drop ||= 0.05;
  args.state.money_boost_drop ||= 0.1;
  args.state.instakill_boost_drop ||= 0.05;
  args.state.nuke_boost_drop ||= 0.01;
  args.state.builder_boost_drop ||= 0.1;
  args.state.building_boost_drop ||= 0.1;


  # Game functions
  handlePlayerMovement args
  render args
end