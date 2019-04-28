extends Node2D

onready var im = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")
onready var message_box = get_node("/root/Main/UILayer/MessageBox")
onready var audio_player = get_node("/root/Main/AudioStreamPlayer")

const MAX_NOTE_DIST = 20;
const THRESHOLD = 500;
const N = 4;
const BUFF_VALUE = 10
const DEBUFF_VALUE = -5

var patterns = null;
var active = false;

func _ready():
	get_node("Character1/AnimationPlayer").play("sleep")
	get_node("Character2/AnimationPlayer").play("sleep2")
	get_node("Character1").set_scale(Vector2(0.5, 0.5))
	get_node("Character2").set_scale(Vector2(-0.5, 0.5))
	get_node("Character1/Bottle").set_visible(false)
	get_node("Character2/Bottle").set_visible(false)
	get_node("Character1/Apple").set_visible(false)
	get_node("Character2/Apple").set_visible(false)

func generate_random(n, start_timestamp, possible_keys):
	var inst = load("res://patterns/Pattern.gd")
	return inst.generate_random(n, start_timestamp, 1000, 1000, possible_keys);

func restart():
	bm.clear_preps();
	var raw_pattern = generate_random(N, 0, ["up", "left", "right", "down"]);
	patterns = [[], []];
	for i in range(0, N):
		patterns[i % 2].append(raw_pattern.hits[i]);
		bm.prepare_key(str(i % 2), raw_pattern.hits[i].key, raw_pattern.hits[i].timestamp);
	im.clear()

func on_gain_focus():
	active = true;
	restart()
	message_box.show_main_text("Press the highlighted keys")

func on_lose_focus():
	active = false;
	patterns = null;
	im.clear();
	bm.clear_preps();

func fail(player, key):
	if key == "none":
		pass
	else:
		var button_id = bm.to_id(player, key)
		bm.buttons[button_id].failed()
	restart()

	get_node("/root/Main/UILayer/AffectionBar").modify_player_value(DEBUFF_VALUE, player)
	audio_player.play_failed()

func small_win(player, key):
	get_node("/root/Main/AudioStreamPlayer").play_test_sound()
	if key == "none":
		pass
	else:
		var button_id = bm.to_id(player, key)
		bm.buttons[button_id].succeed()
	get_node("/root/Main/UILayer/AffectionBar").modify_player_value(BUFF_VALUE, player)
	audio_player.play_success()

func win():
	im.clear();
	patterns = null;
	bm.clear_preps();
	get_node("/root/Main").next_scene()

func _process(_delta):
	if not active:
		return
	
	for p in [0, 1]:
		var i = im.get_inputs(p);
		if len(i) > 0 and patterns != null:
			if i[0].input != patterns[p][0].key:
				if p == 0:
					$Character1.spawn_emote("miss")
				else:
					$Character2.spawn_emote("miss")
				fail(p, i[0].input);
				return
			if abs(i[0].time - patterns[p][0].timestamp) >= THRESHOLD:
				if p == 0:
					$Character1.spawn_emote("miss")
				else:
					$Character2.spawn_emote("miss")
				fail(p, i[0].input);
				return
			small_win(p, i[0].input)
			bm.preps[bm.to_id(str(p), i[0].input)].pop_front();
			i.pop_front();
			patterns[p].pop_front();
			
			if p == 0:
				$Character1.spawn_emote("rested")
			else:
				$Character2.spawn_emote("rested")
			if len(patterns[0]) == 0 and len(patterns[1]) == 0:
				win()
	
		var ct = im.get_current_time()
		if patterns != null and len(patterns[p]) > 0 and patterns[p][0].timestamp <= ct - THRESHOLD:
			fail(p, "none")