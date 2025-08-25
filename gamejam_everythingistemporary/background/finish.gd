extends Sprite2D

var curkeys = 0
var keys = -1
var label
var plats
var initial_pos

func _ready():
	var invert_shader = Shader.new()
	invert_shader.code = """
	shader_type canvas_item;
	uniform float alpha;
	void fragment() {
		vec4 tex_color = texture(TEXTURE, UV);
		COLOR = vec4(1.0 - tex_color.rgb, tex_color.a * alpha);
	}
	"""
	var shader_material = ShaderMaterial.new()
	shader_material.shader = invert_shader
	material = shader_material
	(material as ShaderMaterial).set_shader_parameter("alpha", 1.0)

func initialize(tot_keys):
	keys = tot_keys
	var tr = Vector2(-100, -100)
	var tl = Vector2(100, -100)
	var bl = Vector2(100, 100)
	var br = Vector2(-100, 100)
	plats = Node2D.new()
	var s = GDScript.new()
	s.source_code = "extends Node2D\nfunc within_camera(r): return get_parent().within_camera(r)"
	s.reload()
	plats.set_script(s)
	var p = Platform.new()
	p.initialize([tl, tr])
	plats.add_child(p)
	p = Platform.new()
	p.initialize([tr, br])
	plats.add_child(p)
	p = Platform.new()
	p.initialize([br, bl])
	plats.add_child(p)
	p = Platform.new()
	p.initialize([bl, tl])
	plats.add_child(p)
	add_child(plats)
	label = Label.new()
	label.size = Vector2(400, 200)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = str(curkeys) + '/' + str(keys) + ' keys'
	label.add_theme_font_size_override("font_size", 30)
	label.position = Vector2(-200, -230)
	add_child(label)

func _process(dt):
	(material as ShaderMaterial).set_shader_parameter("alpha", get_parent().modulate.a)
	if keys == -1:
		return
	if initial_pos == null:
		initial_pos = global_position
	plats.position = initial_pos - global_position
	label.position = Vector2(-200, -230) + initial_pos - global_position

func add_key():
	curkeys += 1
	label.text = str(curkeys) + '/' + str(keys) + ' keys'
	
func get_prot(center, radius):
	var res = Vector2.ZERO
	var modpos = center - plats.global_position
	for child in plats.get_children():
		var cur = child.circle_protrusion_vec(modpos, radius)
		if cur.length() > 0.1:
			res += cur
			if curkeys >= keys:
				child.ticks = child.max_ticks + 1
	return res
	
func within_camera(rect):
	return get_parent().get_parent().within_camera(Rect2(global_position + rect.position, rect.size))
	
