extends Node2D

var BUTTON = preload("res://button/Button.tscn");

func _init():
	for player in ["0", "1"]:
		for key in ["up", "down", "left", "right"]:
			var button = BUTTON.instance();
			button.play("p" + player + "_" + key);

			var dim = OS.get_screen_size();

			var screenx = dim.x;
			var screeny = dim.y;
			var button_size = 64;

			var posx = screenx / 4;
			if player == "1":
				posx += screenx / 2;
			if key == "left":
				posx -= button_size * 2;
			if key == "right":
				posx += button_size * 2;
			
			var posy = screeny - button_size * 2;
			if key == "up": posy -= button_size * 2;

			button.position.x = posx;
			button.position.y = posy;
			add_child(button);