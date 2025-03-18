extends Node2D

# Game States
enum GameState {MENU, PLAYING, TRANSITION}
var current_state = GameState.MENU

var viewport_size = Vector2.ZERO
var ui_scale = 1.0
var background_color = Color(0.15, 0.15, 0.18)  # Slightly blue-gray dark background
var accent_color = Color(0.3, 0.7, 0.9)  # Light blue accent
var title_font_size = 32
var button_font_size = 18

# Game Variables
var current_game = ""
var available_games = ["BOREDOM", "ANXIETY", "GUILT", "SELF_HATE", "DEPRESSION", 
					   "MEANINGLESSNESS", "ADDICTION", "LONELINESS", 
					   "SELF_COMPASSION", "OVERWHELMED"]

# UI Elements
var main_label : Label
var instruction_label : Label
var back_button : Button
var background : ColorRect

# Game Specific Variables
# BOREDOM game
var circles = []
var rectangles = []
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.PURPLE]
var circle_positions = []
var rectangle_positions = []
var dragging_circle = null
var dragging_offset = Vector2.ZERO
var boredom_stage = 0
var boredom_messages = [
	"Arrange the caps on their matching pens. DON'T EVEN THINK ABOUT MISMATCHING COLORS!",
	"That's not right. Try a different arrangement.",
	"Still not correct. Try again but differently.",
	"Not quite. Notice your frustration. How does boredom feel?",
	"Keep trying. Notice the urge to quit.",
	"What does boredom feel like in your body?",
	"Can you stay with this feeling a bit longer?",
	"Boredom isn't something to fix. It's just a feeling.",
	"Notice your thoughts as you perform this meaningless task.",
	#"You've spent enough time with boredom. Press back to return."
]
var arrangements_tried = 0

# ANXIETY game
var timers = []
var timer_bars = []
var anxiety_stage = 0
var anxiety_messages = [
	"Tap each timer before it runs out.",
	"Notice your heart rate increasing.",
	"What will happen if you just let go?",
	"What thoughts arise when you can't keep up?",
	"Can you be present with this feeling without trying to control it?",
	"Anxiety is just energy in the body.",
	"Notice where you feel it physically.",
	"You've spent enough time with anxiety. Press back to return."
]
var timer_spawn_rate = 3.0
var timer_spawn_timer = 0.0
var max_timers = 5

# GUILT game
var plant
var plant_stages = []
var plant_health = 100
var options_buttons = []
var guilt_stage = 0
var guilt_options = [
	["Water the plant", "Give it sunlight", "Add fertilizer"],
	["Sing to the plant", "Relocate the plant", "Prune the leaves"],
	["Apologize to the plant", "Read to the plant", "Talk to the plant"]
]
var guilt_messages = [
	"Your plant needs care. What will you do?",
	"The plant seems to be wilting despite your efforts.",
	"No matter what you do, the plant continues to decline.",
	"Notice the feeling of responsibility.",
	"What stories does your mind tell about your failure?",
	"Can you acknowledge these feelings without judgment?",
	"Guilt is an emotion, not a fact about you.",
	"You've spent enough time with guilt. Press back to return."
]
var choices_made = 0

# SELF HATE game
var silhouette
var thought_labels = []
var thoughts = [
	"I'm not good enough",
	"I always mess up",
	"Nobody likes me",
	"I'm a failure",
	"I don't deserve good things",
	"I can't do anything right",
	"I'm worthless",
	"Everyone is better than me"
]
var self_hate_stage = 0
var self_hate_messages = [
	"This is your reflection. Tap on the negative thoughts to remove them.",
	"Notice how they keep coming back.",
	"What happens when you try to fight these thoughts?",
	"Can you observe them without believing them?",
	"These thoughts are not facts about you.",
	"Notice where you feel the reaction to these thoughts in your body.",
	"Self-judgment is just a habit of mind, not truth.",
	"You've spent enough time with self-hate. Press back to return."
]
var thoughts_clicked = 0

# DEPRESSION game
var player_character
var player_speed = 1.0
var screen_darkness = 0.0
var darkness_overlay
var depression_stage = 0
var depression_messages = [
	"Move forward using the arrow keys or by tapping left/right sides of the screen.",
	"Notice how difficult movement feels.",
	"The world seems to be getting darker.",
	"What does the heaviness feel like in your body?",
	"Can you continue moving despite the weight?",
	"Depression changes how we perceive the world.",
	"Notice the effort it takes to keep going.",
	"You've spent enough time with depression. Press back to return."
]
var steps_taken = 0

# MEANINGLESSNESS game
var objects = []
var object_types = ["circle", "square", "triangle"]
var structure
var meaninglessness_stage = 0
var meaninglessness_messages = [
	"Collect shapes and place them in the structure.",
	"Notice what you've built disappearing.",
	"Start building again.",
	"What does it feel like when your efforts seem pointless?",
	"Notice the desire for purpose.",
	"Can you continue without attaching to outcomes?",
	"Meaninglessness is a feeling, not a truth about life.",
	"You've spent enough time with meaninglessness. Press back to return."
]
var structures_built = 0

# ADDICTION game
var bubbles = []
var bubble_spawn_timer = 0.0
var bubble_spawn_rate = 0.5
var pleasure_meter
var side_effect_overlay
var pleasure_value = 100
var side_effect_value = 0
var addiction_stage = 0
var addiction_messages = [
	"Pop the bubbles for a pleasant sensation.",
	"Notice how the feeling becomes less intense over time.",
	"Keep popping to maintain the feeling.",
	"Notice the side effects increasing.",
	"Can you observe the craving without acting on it?",
	"What happens in your body when you resist?",
	"Addiction is about chasing a feeling that never lasts.",
	"You've spent enough time with addiction. Press back to return."
]
var bubbles_popped = 0

# LONELINESS game
var player_figure
var other_figures = []
var loneliness_stage = 0
var loneliness_messages = [
	"Move around and try to connect with other figures.",
	"Notice how they remain just out of reach.",
	"What does the longing for connection feel like?",
	"Where do you feel this in your body?",
	"Can you be present with yourself in this moment?",
	"Loneliness is a feeling, not a permanent state.",
	"We can feel lonely even when surrounded by others.",
	"You've spent enough time with loneliness. Press back to return."
]
var connection_attempts = 0

# SELF COMPASSION game
var target
var player_cursor
var failure_count = 0
var compassion_stage = 0
var compassion_messages = [
	"Try to keep your cursor on the moving target.",
	"Notice your frustration when you fail.",
	"It's okay to struggle with this.",
	"Place your hand on your heart.",
	"What would you say to a friend who struggled with this?",
	"Can you offer yourself the same kindness?",
	"Self-compassion begins with acknowledging difficulty.",
	"You've spent enough time with self-compassion. Press back to return."
]
var target_speed = 2.0

# OVERWHELMED game
var tasks = []
var task_types = ["sort", "count", "balance"]
var noise_particles = []
var overwhelm_stage = 0
var overwhelm_messages = [
	"Complete all tasks simultaneously.",
	"Notice the feeling of being pulled in many directions.",
	"Can you find your breath amid the chaos?",
	"Notice one sensation at a time.",
	"What happens when you try to control everything?",
	"Overwhelm is temporary, even when it feels endless.",
	"Can you be with the discomfort without fixing it?",
	"You've spent enough time with overwhelm. Press back to return."
]
var tasks_attempted = 0

func _ready():
	# Initialize viewport size first
	viewport_size = get_viewport_rect().size
	
	# Create UI elements
	create_ui()
	
	# Connect to window resize signal
	get_tree().get_root().size_changed.connect(setup_responsive_ui)
	
	# Initialize the menu last, after UI is created
	show_menu()
	
	# Set up randomization
	randomize()
	# Fix for positioning issues
	get_tree().root.connect("size_changed", fix_positioning)
	call_deferred("fix_positioning")  # Call after UI is built
	set_process_input(true)
	
# Add this function to your script
func fix_game_positioning():
	# Get the current viewport dimensions
	viewport_size = get_viewport_rect().size
	var center_x = viewport_size.x / 2
	var center_y = viewport_size.y / 2
	
	# Center the game based on which game is active
	match current_game:
		"BOREDOM":
			# Center the boredom game
			var spacing = viewport_size.x * 0.1
			
			# Reposition the circles (caps)
			for i in range(circles.size()):
				var circle_size = circles[i].size
				circles[i].position = Vector2(
					center_x + (i - 2) * spacing - circle_size.x/2,
					center_y - 100 - circle_size.y/2
				)
			
			# Reposition the rectangles (pens)
			for i in range(rectangles.size()):
				var rect_size = rectangles[i].size
				rectangles[i].position = Vector2(
					center_x + (i - 2) * spacing - rect_size.x/2,
					center_y + 50 - rect_size.y/2
				)
		
		#"ANXIETY":
			## Center the anxiety game (timer bars)
			#for i in range(timer_bars.size()):
				#var bar = timer_bars[i]
				## Adjust position while maintaining relative placement
				#bar.position = Vector2(
					#center_x - 200 + (bar.position.x % 300),  # Create a spread across center
					#center_y - 100 + (bar.position.y % 200)   # Distribute vertically around center
				#)
		
		"GUILT":
			# Center the guilt game (plant and buttons)
			if plant:
				plant.position = Vector2(center_x - plant.size.x/2, center_y - plant.size.y/2)
			
			# Center option buttons below the plant
			var button_width = 200
			for i in range(options_buttons.size()):
				var button = options_buttons[i]
				button.position = Vector2(
					center_x - button_width/2,
					center_y + 80 + i * 60
				)
				button.size.x = button_width
		
		"SELF_HATE":
			# Center the silhouette
			if silhouette:
				silhouette.position = Vector2(center_x - silhouette.size.x/2, center_y - silhouette.size.y/2)
			
			# Reposition thoughts around the centered silhouette
			for thought in thought_labels:
				var original_distance = thought.position.distance_to(Vector2(512, 350))
				var original_angle = (thought.position - Vector2(512, 350)).angle()
				
				# Keep the same angle and distance but from new center
				thought.position = Vector2(
					center_x + cos(original_angle) * original_distance,
					center_y + sin(original_angle) * original_distance
				)
		
		"DEPRESSION":
			# Center the depression game
			if player_character:
				# Keep x position (for left-to-right progress) but center vertically
				player_character.position.y = center_y - player_character.size.y/2
			
			# Resize darkness overlay to cover the screen
			if darkness_overlay:
				darkness_overlay.position = Vector2.ZERO
				darkness_overlay.size = viewport_size
		
		"MEANINGLESSNESS":
			# Center the structure area
			if structure:
				structure.position = Vector2(center_x - structure.size.x/2, center_y - structure.size.y/2)
			
			# Reposition objects around the structure
			for obj_data in objects:
				var obj = obj_data.node
				# Keep relative position but shift from old center (512) to new center
				var dx = obj.position.x - 512
				var dy = obj.position.y - 384
				obj.position = Vector2(center_x + dx, center_y + dy)
		
		"ADDICTION":
			# Center the addiction meters
			if pleasure_meter:
				pleasure_meter.position = Vector2(center_x - 100, center_y - 150)
			
			# Resize side effect overlay to cover the screen
			if side_effect_overlay:
				side_effect_overlay.position = Vector2.ZERO
				side_effect_overlay.size = viewport_size
			
			# Reposition any labels that might be associated with meters
			var children = get_children()
			for child in children:
				if child is Label and child != main_label and child != instruction_label:
					if child.text == "Pleasure":
						child.position = Vector2(center_x - 150, center_y - 150)
					elif child.text == "Side Effects":
						child.position = Vector2(center_x - 150, center_y - 120)
			
			# Bubbles don't need centering as they're randomly placed
		
		"LONELINESS":
			# Center the player figure
			if player_figure:
				player_figure.position = Vector2(center_x - player_figure.size.x/2, center_y - player_figure.size.y/2)
			
			# Adjust other figures positions relative to center
			for figure_data in other_figures:
				var figure = figure_data.node
				# Keep relative position but shift from old center (512) to new center
				var dx = figure.position.x - 512
				var dy = figure.position.y - 384
				figure.position = Vector2(center_x + dx, center_y + dy)
				
				# Also update the target positions
				figure_data.target_x = center_x + (figure_data.target_x - 512)
				figure_data.target_y = center_y + (figure_data.target_y - 384)
		
		"SELF_COMPASSION":
			# Center the target and cursor
			if target:
				# Keep the movement pattern but centered
				target.position = Vector2(center_x - target.size.x/2, center_y - target.size.y/2)
			
			if player_cursor:
				player_cursor.position = Vector2(center_x - player_cursor.size.x/2, center_y - player_cursor.size.y/2)
		
		"OVERWHELMED":
			# Center the task areas
			var task_width = 200
			var spacing = 40
			var start_x = center_x - (task_width * 3 + spacing * 2) / 2
			
			for i in range(tasks.size()):
				var task = tasks[i]
				if task.node:
					var new_x = start_x + i * (task_width + spacing)
					var dx = new_x - task.node.position.x
					
					# Move the task area
					task.node.position.x = new_x
					task.node.position.y = center_y - 75
					
					# Move all associated elements by the same delta
					for element in task.elements:
						element.position.x += dx
						# Keep vertical position relative to task area
						var dy = element.position.y - (task.node.position.y - dx)
						element.position.y = task.node.position.y + dy
			
			# Noise particles spread across the screen (no need to center)
	
	# Position instruction closer to the game elements in all cases
	instruction_label.position = Vector2(
		(viewport_size.x - instruction_label.size.x) / 2,
		center_y + 200
	)
	
	# Center the main label
	main_label.position = Vector2(
		(viewport_size.x - main_label.size.x) / 2,
		50  # Keep it at the top
	)
				
func fix_positioning():
	if main_label:
		main_label.position.x = (viewport_size.x - main_label.size.x) / 2
	
	if instruction_label:
		instruction_label.position.x = (viewport_size.x - instruction_label.size.x) / 2
		instruction_label.position.y = viewport_size.y - instruction_label.size.y - 100
	
	# Fix game elements positioning
	if current_game == "BOREDOM" and circles.size() > 0:
		var center_x = viewport_size.x / 2
		var center_y = viewport_size.y / 2
		var spacing = viewport_size.x * 0.1
		var circle_size = circles[0].size.x
		var rect_width = rectangles[0].size.x
		
		for i in range(circles.size()):
			circles[i].position = Vector2(
				center_x + (i - 2) * spacing - circle_size/2,
				center_y - spacing - circle_size/2
			)
		
		for i in range(rectangles.size()):
			rectangles[i].position = Vector2(
				center_x + (i - 2) * spacing - rect_width/2,
				center_y + spacing - rectangles[i].size.y/2
			)
			
# Add this new function for responsive UI
func setup_responsive_ui():
	viewport_size = get_viewport_rect().size
	
	# Calculate scale based on viewport size
	var base_height = 768.0
	ui_scale = min(viewport_size.y / base_height, 1.2)
	
	# Update background
	if background:
		background.size = Vector2(viewport_size.x + 1000, viewport_size.y + 1000)
		background.position = Vector2(-500, -500)
	
	# Update labels if they exist - check for null first
	if main_label != null:
		main_label.position = Vector2(viewport_size.x / 2, viewport_size.y * 0.1)
		main_label.size = Vector2(viewport_size.x * 0.8, viewport_size.y * 0.1)
		main_label.add_theme_font_size_override("font_size", int(title_font_size * ui_scale))
	
	if instruction_label != null:
		instruction_label.position = Vector2(viewport_size.x / 2, viewport_size.y * 0.1)
		instruction_label.size = Vector2(viewport_size.x * 0.8, viewport_size.y * 0.1)
		instruction_label.add_theme_font_size_override("font_size", int(button_font_size * ui_scale))
	
	if back_button != null:
		back_button.position = Vector2(viewport_size.x * 0.05, viewport_size.y * 0.05)
		back_button.size = Vector2(viewport_size.x * 0.1, viewport_size.y * 0.06)
	
	# Only recreate menu if we're in menu state and UI is already created
	if current_state == GameState.MENU and main_label != null:
		show_menu()

func create_ui():
	# Create background
	background = ColorRect.new()
	background.size = Vector2(2000, 2000)  # Make it large enough
	background.position = Vector2(-500, -500)  # Position it to ensure coverage
	background.color = background_color
	background.name = "Background"
	add_child(background)
	
	# Create main label with better styling
	main_label = Label.new()
	main_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	main_label.position = Vector2(viewport_size.x / 2, viewport_size.y * 0.15)
	main_label.size = Vector2(viewport_size.x * 0.8, viewport_size.y * 0.1)
	main_label.add_theme_color_override("font_color", Color.WHITE)
	main_label.add_theme_font_size_override("font_size", int(title_font_size * ui_scale))
	add_child(main_label)
	
	# Create instruction label with better styling
	instruction_label = Label.new()
	instruction_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instruction_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	instruction_label.position = Vector2(viewport_size.x / 2, viewport_size.y * 0.85)
	instruction_label.size = Vector2(viewport_size.x * 0.8, viewport_size.y * 0.1)
	instruction_label.add_theme_color_override("font_color", Color.WHITE)
	instruction_label.add_theme_font_size_override("font_size", int(button_font_size * ui_scale))
	add_child(instruction_label)
	
	# Create styled back button
	back_button = Button.new()
	back_button.text = "Back"
	back_button.position = Vector2(viewport_size.x * 0.05, viewport_size.y * 0.05)
	back_button.size = Vector2(viewport_size.x * 0.1, viewport_size.y * 0.06)
	back_button.add_theme_color_override("font_color", Color.WHITE)
	back_button.add_theme_color_override("font_hover_color", Color.WHITE)
	back_button.add_theme_color_override("bg_color", accent_color)
	back_button.add_theme_color_override("bg_hover_color", accent_color.lightened(0.2))
	back_button.pressed.connect(_on_back_button_pressed)
	add_child(back_button)
	back_button.hide()


func show_menu():
	# Make sure we have valid UI elements before trying to use them
	if main_label == null or instruction_label == null:
		print("UI elements not initialized properly")
		return
		
	current_state = GameState.MENU
	main_label.text = "Emotional Awareness Games"
	main_label.position.x = (viewport_size.x - main_label.size.x) / 2
	
	instruction_label.text = "Click on an emotion to begin"
	# Put the instruction at the bottom of the screen for the menu
	instruction_label.position = Vector2(
		(viewport_size.x - instruction_label.size.x) / 2,
		viewport_size.y - instruction_label.size.y - 50
	)
	
	# Remove any existing game objects
	clear_game_objects()
	
	# Create menu buttons
	var num_games = available_games.size()
	var button_height = viewport_size.y * 0.07
	var button_width = viewport_size.x * 0.4
	var spacing = (viewport_size.y * 0.6) / (num_games + 1)
	var start_y = viewport_size.y * 0.25
	
	for i in range(available_games.size()):
		var game_name = available_games[i]
		var button = Button.new()
		button.text = game_name.capitalize().replace("_", " ")
		button.position = Vector2(viewport_size.x / 2 - button_width / 2, start_y + i * spacing)
		button.size = Vector2(button_width, button_height)
		
		# Style the button
		button.add_theme_color_override("font_color", Color.WHITE)
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_color_override("bg_color", Color(0.2, 0.2, 0.25))
		button.add_theme_color_override("bg_hover_color", accent_color)
		button.add_theme_font_size_override("font_size", int(button_font_size * ui_scale))
		
		button.pressed.connect(func(): _on_game_selected(game_name))
		add_child(button)

func clear_game_objects():
	# Remove all children except main UI elements
	for child in get_children():
		if child != main_label and child != instruction_label and child != back_button:
			child.queue_free()
	
	# Clear game-specific arrays
	circles.clear()
	rectangles.clear()
	timers.clear()
	timer_bars.clear()
	options_buttons.clear()
	thought_labels.clear()
	objects.clear()
	bubbles.clear()
	other_figures.clear()
	tasks.clear()
	noise_particles.clear()

func _on_game_selected(game_name):
	current_game = game_name
	start_game(game_name)

func _on_back_button_pressed():
	show_menu()
	back_button.hide()

func start_game(game_name):
	current_state = GameState.PLAYING
	clear_game_objects()
	back_button.show()
	
	main_label.text = game_name.capitalize().replace("_", " ")
	main_label.position.x = (viewport_size.x - main_label.size.x) / 2
	
	match game_name:
		"BOREDOM":
			setup_boredom_game()
		"ANXIETY":
			setup_anxiety_game()
		"GUILT":
			setup_guilt_game()
		"SELF_HATE":
			setup_self_hate_game()
		"DEPRESSION":
			setup_depression_game()
		"MEANINGLESSNESS":
			setup_meaninglessness_game()
		"ADDICTION":
			setup_addiction_game()
		"LONELINESS":
			setup_loneliness_game()
		"SELF_COMPASSION":
			setup_self_compassion_game()
		"OVERWHELMED":
			setup_overwhelmed_game()
	
	call_deferred("fix_game_positioning")

# BOREDOM GAME IMPLEMENTATION
func setup_boredom_game():
	boredom_stage = 0
	arrangements_tried = 0
	instruction_label.text = boredom_messages[boredom_stage]
	
	# Setup circle positions (caps)
	circle_positions = [
		Vector2(300, 300),
		Vector2(400, 300),
		Vector2(500, 300),
		Vector2(600, 300),
		Vector2(700, 300)
	]
	
	# Setup rectangle positions (pens)
	rectangle_positions = [
		Vector2(300, 450),
		Vector2(400, 450),
		Vector2(500, 450),
		Vector2(600, 450),
		Vector2(700, 450)
	]
	
	# Create circles (caps)
	for i in range(5):
		var circle = ColorRect.new()
		circle.size = Vector2(50, 50)
		circle.position = circle_positions[i] - Vector2(25, 25)
		circle.color = colors[i]
		
		# Make the ColorRect circular by applying a shader
		var shader = load("res://circle_shader.gdshader")
		if shader:
			var material = ShaderMaterial.new()
			material.shader = shader
			circle.material = material
		
		add_child(circle)
		circles.append(circle)
	
	# Create rectangles (pens)
	for i in range(5):
		var rect = ColorRect.new()
		rect.size = Vector2(30, 80)
		rect.position = rectangle_positions[i] - Vector2(15, 40)
		rect.color = colors[i]
		add_child(rect)
		rectangles.append(rect)

func handle_boredom_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if we're clicking on a circle
				for i in range(circles.size()):
					var circle = circles[i]
					var circle_rect = Rect2(circle.position, circle.size)
					if circle_rect.has_point(event.position):
						dragging_circle = i
						dragging_offset = event.position - circle.position
						break
			else:  # Released
				if dragging_circle != null:
					# Check if circle is dropped on a rectangle
					var circle = circles[dragging_circle]
					for i in range(rectangles.size()):
						var rect = rectangles[i]
						var rect_top = Rect2(rect.position, Vector2(rect.size.x, 10))
						if rect_top.has_point(event.position):
							# Snap to position
							circle.position = rect.position + Vector2(10, -circle.size.y)
							
							# After every arrangement, advance the game
							advance_boredom_game()
							break
					
					dragging_circle = null
	
	elif event is InputEventMouseMotion and dragging_circle != null:
		circles[dragging_circle].position = event.position - dragging_offset
	
	if event is InputEventMouseMotion and dragging_circle != null:
		circles[dragging_circle].position = event.position - dragging_offset

func advance_boredom_game():
	arrangements_tried += 1
	
	# Every second arrangement, advance the stage
	if arrangements_tried % 2 == 0:
		boredom_stage = min(boredom_stage + 1, boredom_messages.size() - 1)
		instruction_label.text = boredom_messages[boredom_stage]

# ANXIETY GAME IMPLEMENTATION
func setup_anxiety_game():
	anxiety_stage = 0
	timer_spawn_rate = 3.0
	timer_spawn_timer = 0.0
	instruction_label.text = anxiety_messages[anxiety_stage]
	
	# Create initial timer
	spawn_timer()

func handle_anxiety_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Check if clicking on a timer
			for i in range(timer_bars.size()):
				var bar = timer_bars[i]
				var bar_rect = Rect2(bar.position, bar.size)
				if bar_rect.has_point(event.position):
					# Remove this timer
					if timer_bars[i]:
						timer_bars[i].queue_free()
					if timers[i]:
						timers.remove_at(i)
						timer_bars.remove_at(i)
						
						# Advance game
						if anxiety_stage < 2:
							anxiety_stage += 1
							instruction_label.text = anxiety_messages[anxiety_stage]
						break

func spawn_timer():
	# Create a timer bar
	var bar = ColorRect.new()
	bar.size = Vector2(100, 20)
	bar.position = Vector2(randf_range(100, 924), randf_range(200, 500))
	bar.color = Color(0.0, 0.8, 0.0)
	add_child(bar)
	
	# Add to arrays
	var timer_duration = randf_range(2.0, 5.0)
	timers.append({"duration": timer_duration, "remaining": timer_duration})
	timer_bars.append(bar)

func _process(delta):
	if current_state != GameState.PLAYING:
		return
		
	# Game-specific processing
	match current_game:
		"ANXIETY":
			process_anxiety_game(delta)
		"DEPRESSION":
			process_depression_game(delta)
		"ADDICTION":
			process_addiction_game(delta)
		"LONELINESS":
			process_loneliness_game(delta)
		"SELF_COMPASSION":
			process_self_compassion_game(delta)
		"OVERWHELMED":
			process_overwhelmed_game(delta)

func process_anxiety_game(delta):
	# Update existing timers
	for i in range(timers.size()):
		if i >= timers.size():
			break
			
		timers[i].remaining -= delta
		
		# Update bar size
		if i < timer_bars.size() and timer_bars[i]:
			var percentage = timers[i].remaining / timers[i].duration
			timer_bars[i].size.x = 100 * percentage
			
			# Update color based on time left
			if percentage > 0.6:
				timer_bars[i].color = Color(0.0, 0.8, 0.0)
			elif percentage > 0.3:
				timer_bars[i].color = Color(0.8, 0.8, 0.0)
			else:
				timer_bars[i].color = Color(0.8, 0.0, 0.0)
			
			# Timer expired
			if timers[i].remaining <= 0:
				timer_bars[i].queue_free()
				timers.remove_at(i)
				timer_bars.remove_at(i)
				
				# Advance message if timers are being lost
				if anxiety_stage < anxiety_messages.size() - 1:
					anxiety_stage = min(anxiety_stage + 1, anxiety_messages.size() - 1)
					instruction_label.text = anxiety_messages[anxiety_stage]
	
	# Spawn new timers
	timer_spawn_timer += delta
	if timer_spawn_timer >= timer_spawn_rate and timers.size() < max_timers:
		spawn_timer()
		timer_spawn_timer = 0
		
		# Make it faster over time
		timer_spawn_rate = max(1.0, timer_spawn_rate - 0.1)

# GUILT GAME IMPLEMENTATION
func setup_guilt_game():
	guilt_stage = 0
	choices_made = 0
	plant_health = 100
	instruction_label.text = guilt_messages[guilt_stage]
	
	# Create plant
	plant = ColorRect.new()
	plant.size = Vector2(50, 100)
	plant.position = Vector2(512 - 25, 300)
	plant.color = Color(0.0, 0.8, 0.0)
	add_child(plant)
	
	# Create option buttons
	display_guilt_options()

func display_guilt_options():
	# Clear previous buttons
	for button in options_buttons:
		button.queue_free()
	options_buttons.clear()
	
	# Get current options
	var options = guilt_options[min(choices_made, guilt_options.size() - 1)]
	
	# Create new buttons
	var button_y = 450
	for option in options:
		var button = Button.new()
		button.text = option
		button.position = Vector2(512 - 100, button_y)
		button.size = Vector2(200, 40)
		button.pressed.connect(func(): _on_guilt_option_selected(option))
		add_child(button)
		options_buttons.append(button)
		button_y += 50

func _on_guilt_option_selected(option):
	# No matter what option is selected, the plant health declines
	plant_health -= 15
	
	# Update plant appearance
	plant.color = Color(0.0, max(0.3, plant_health / 100.0 * 0.8), 0.0)
	plant.size.y = max(10, plant_health)
	plant.position.y = 300 + (100 - plant.size.y)
	
	# Increment choices and advance stage
	choices_made += 1
	if choices_made % 2 == 0 or plant_health <= 30:
		guilt_stage = min(guilt_stage + 1, guilt_messages.size() - 1)
		instruction_label.text = guilt_messages[guilt_stage]
	
	# Display new options
	display_guilt_options()

# SELF HATE GAME IMPLEMENTATION
func setup_self_hate_game():
	self_hate_stage = 0
	thoughts_clicked = 0
	instruction_label.text = self_hate_messages[self_hate_stage]
	
	# Create silhouette
	silhouette = ColorRect.new()
	silhouette.size = Vector2(100, 200)
	silhouette.position = Vector2(512 - 50, 250)
	silhouette.color = Color(0.5, 0.5, 0.5)
	add_child(silhouette)
	
	# Create initial thoughts
	spawn_thoughts(3)

func spawn_thoughts(num_thoughts):
	for i in range(num_thoughts):
		var thought = Label.new()
		thought.text = thoughts[randi() % thoughts.size()]
		thought.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		thought.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		# Position around the silhouette
		var angle = randf_range(0, 2 * PI)
		var distance = randf_range(100, 200)
		var pos_x = 512 + cos(angle) * distance
		var pos_y = 350 + sin(angle) * distance
		
		thought.position = Vector2(pos_x - 75, pos_y)
		thought.size = Vector2(150, 50)
		thought.add_theme_color_override("font_color", Color(0.8, 0.0, 0.0))
		
		# Make it a button instead of a label for better click handling
		var button = Button.new()
		button.text = thought.text
		button.position = thought.position
		button.size = thought.size
		button.add_theme_color_override("font_color", Color(0.8, 0.0, 0.0))
		button.add_theme_color_override("font_color_hover", Color(1.0, 0.0, 0.0))
		var current_index = thought_labels.size()
		button.pressed.connect(func(): _on_thought_input(current_index))
		
		add_child(button)
		thought_labels.append(button)

func _on_thought_input(thought_index):
	if thought_index < thought_labels.size():
		thought_labels[thought_index].visible = false
		
		# Schedule reappearance
		var timer = Timer.new()
		timer.wait_time = 1.5
		timer.one_shot = true
		timer.timeout.connect(func(): _on_thought_reappear(thought_index))
		add_child(timer)
		timer.start()
		
		# Advance game
		thoughts_clicked += 1
		if thoughts_clicked % 3 == 0:
			self_hate_stage = min(self_hate_stage + 1, self_hate_messages.size() - 1)
			instruction_label.text = self_hate_messages[self_hate_stage]
			
			# Add new thoughts
			spawn_thoughts(1)

func _on_thought_reappear(thought_index):
	if thought_index < thought_labels.size():
		thought_labels[thought_index].visible = true

# DEPRESSION GAME IMPLEMENTATION
func setup_depression_game():
	depression_stage = 0
	steps_taken = 0
	screen_darkness = 0.0
	instruction_label.text = depression_messages[depression_stage]
	
	# Create player character
	player_character = ColorRect.new()
	player_character.size = Vector2(50, 100)
	player_character.position = Vector2(100, 350)
	player_character.color = Color(0.8, 0.8, 0.8)
	add_child(player_character)
	
	# Create darkness overlay
	darkness_overlay = ColorRect.new()
	darkness_overlay.size = Vector2(1024, 768)
	darkness_overlay.position = Vector2(0, 0)
	darkness_overlay.color = Color(0, 0, 0, 0)  # Start transparent
	add_child(darkness_overlay)
	
	# Make sure darkness is behind text but over other elements
	move_child(darkness_overlay, 1)

func process_depression_game(delta):
	# Move character based on input
	if Input.is_action_pressed("ui_right"):
		player_character.position.x += player_speed
		take_depression_step()
	elif Input.is_action_pressed("ui_left"):
		player_character.position.x -= player_speed
		take_depression_step()
	
	# Keep character on screen
	player_character.position.x = clamp(player_character.position.x, 0, 1024 - player_character.size.x)
	
	# Gradually slow down movement
	player_speed = max(0.2, player_speed - 0.0001)
	
	# Update darkness
	if screen_darkness < 0.7:  # Don't make it completely dark
		screen_darkness += 0.0001
		darkness_overlay.color = Color(0, 0, 0, screen_darkness)

func handle_depression_input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Move based on which side of the screen was touched
		if event.position.x < 512:
			player_character.position.x -= 10
		else:
			player_character.position.x += 10
		
		take_depression_step()

func take_depression_step():
	steps_taken += 1
	if steps_taken % 20 == 0:
		depression_stage = min(depression_stage + 1, depression_messages.size() - 1)
		instruction_label.text = depression_messages[depression_stage]

# MEANINGLESSNESS GAME IMPLEMENTATION
func setup_meaninglessness_game():
	meaninglessness_stage = 0
	structures_built = 0
	instruction_label.text = meaninglessness_messages[meaninglessness_stage]
	
	# Create structure area
	structure = ColorRect.new()
	structure.size = Vector2(200, 200)
	structure.position = Vector2(512 - 100, 300)
	structure.color = Color(0.2, 0.2, 0.2)
	add_child(structure)
	
	# Spawn initial objects
	spawn_objects(5)

func spawn_objects(num_objects):
	for i in range(num_objects):
		var obj = ColorRect.new()
		
		# Determine shape and size
		var obj_type = object_types[randi() % object_types.size()]
		var size = Vector2(30, 30)
		
		# Set position away from structure
		var pos_x = randf_range(50, 974)
		if pos_x > 362 && pos_x < 662:  # If in structure area
			if randf() > 0.5:
				pos_x = randf_range(50, 362)
			else:
				pos_x = randf_range(662, 974)
		
		var pos_y = randf_range(150, 550)
		if pos_y > 250 && pos_y < 450:  # If in structure area
			if randf() > 0.5:
				pos_y = randf_range(150, 250)
			else:
				pos_y = randf_range(450, 550)
		
		obj.position = Vector2(pos_x, pos_y)
		obj.size = size
		
		# Set color
		obj.color = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0))
		
		# Apply shader for different shapes
		var shader = load("res://circle_shader.gdshader")
		if shader and obj_type == "circle":
			var material = ShaderMaterial.new()
			material.shader = shader
			obj.material = material
		
		# Make draggable
		var current_index = objects.size()
		obj.gui_input.connect(func(evt): _on_object_input(evt, current_index))
		
		add_child(obj)
		objects.append({"node": obj, "type": obj_type, "in_structure": false})

func _on_object_input(event, obj_index):
	if obj_index >= objects.size():
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging
				dragging_circle = obj_index  # Reuse the same variable as boredom game
				dragging_offset = event.position - objects[obj_index].node.position
			else:
				# Stop dragging
				if dragging_circle != null:
					# Check if object is in structure
					var obj = objects[dragging_circle].node
					var structure_rect = Rect2(structure.position, structure.size)
					
					if structure_rect.has_point(obj.position + obj.size / 2):
						objects[dragging_circle].in_structure = true
						
						# Check if structure is complete
						var structure_complete = true
						for obj_data in objects:
							if not obj_data.in_structure:
								structure_complete = false
								break
						
						if structure_complete:
							advance_meaninglessness_game()
					
					dragging_circle = null
	
	elif event is InputEventMouseMotion and dragging_circle != null:
		objects[dragging_circle].node.position = event.position - dragging_offset

func advance_meaninglessness_game():
	structures_built += 1
	
	# Progress message
	meaninglessness_stage = min(meaninglessness_stage + 1, meaninglessness_messages.size() - 1)
	instruction_label.text = meaninglessness_messages[meaninglessness_stage]
	
	# Structure disappears
	for obj_data in objects:
		obj_data.node.queue_free()
	objects.clear()
	
	# Spawn new objects after a brief delay
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(func(): spawn_objects(5))
	add_child(timer)
	timer.start()

# ADDICTION GAME IMPLEMENTATION
func setup_addiction_game():
	addiction_stage = 0
	bubbles_popped = 0
	pleasure_value = 100
	side_effect_value = 0
	bubble_spawn_rate = 0.5
	instruction_label.text = addiction_messages[addiction_stage]
	
	# Create pleasure meter
	pleasure_meter = ColorRect.new()
	pleasure_meter.size = Vector2(200, 20)
	pleasure_meter.position = Vector2(412, 200)
	pleasure_meter.color = Color(0.0, 0.8, 0.0)
	add_child(pleasure_meter)
	
	var pleasure_label = Label.new()
	pleasure_label.text = "Pleasure"
	pleasure_label.position = Vector2(312, 200)
	pleasure_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(pleasure_label)
	
	# Create side effect meter
	side_effect_overlay = ColorRect.new()
	side_effect_overlay.size = Vector2(1024, 768)
	side_effect_overlay.position = Vector2(0, 0)
	side_effect_overlay.color = Color(0.8, 0.0, 0.0, 0.0)  # Start transparent
	add_child(side_effect_overlay)
	
	var side_effect_label = Label.new()
	side_effect_label.text = "Side Effects"
	side_effect_label.position = Vector2(312, 230)
	side_effect_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(side_effect_label)
	
	# Make sure overlay is behind text but over other elements
	move_child(side_effect_overlay, 1)

func process_addiction_game(delta):
	# Spawn bubbles
	bubble_spawn_timer += delta
	if bubble_spawn_timer >= bubble_spawn_rate:
		spawn_bubble()
		bubble_spawn_timer = 0
	
	# Decrease pleasure over time
	if pleasure_value > 0:
		pleasure_value -= 0.1
		pleasure_meter.size.x = (pleasure_value / 100) * 200
	
	# Update side effect overlay
	side_effect_overlay.color = Color(0.8, 0.0, 0.0, side_effect_value / 10)

func spawn_bubble():
	var bubble = ColorRect.new()
	bubble.size = Vector2(30, 30)
	bubble.position = Vector2(randf_range(50, 974), randf_range(250, 500))
	bubble.color = Color(0.0, 0.8, 1.0)
	
	# Make it circular
	var shader = load("res://circle_shader.gdshader")
	if shader:
		var material = ShaderMaterial.new()
		material.shader = shader
		bubble.material = material
	
	# Make it clickable
	var current_index = bubbles.size()
	bubble.gui_input.connect(func(evt): _on_bubble_input(evt, current_index))
	
	add_child(bubble)
	bubbles.append(bubble)

func _on_bubble_input(event, bubble_index):
	if bubble_index >= bubbles.size():
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Pop the bubble
		if bubble_index < bubbles.size():  # Double check the index
			bubbles[bubble_index].queue_free()
			bubbles.remove_at(bubble_index)
			
			# Increase pleasure (diminishing returns)
			pleasure_value = min(100, pleasure_value + (100 - pleasure_value) * 0.2)
			pleasure_meter.size.x = (pleasure_value / 100) * 200
			
			# Increase side effects
			side_effect_value = min(100, side_effect_value + 2)
			
			# Track progress
			bubbles_popped += 1
			if bubbles_popped % 5 == 0:
				addiction_stage = min(addiction_stage + 1, addiction_messages.size() - 1)
				instruction_label.text = addiction_messages[addiction_stage]

# LONELINESS GAME IMPLEMENTATION
func setup_loneliness_game():
	loneliness_stage = 0
	connection_attempts = 0
	instruction_label.text = loneliness_messages[loneliness_stage]
	
	# Create player figure
	player_figure = ColorRect.new()
	player_figure.size = Vector2(40, 40)
	player_figure.position = Vector2(512 - 20, 384 - 20)
	player_figure.color = Color(0.2, 0.6, 1.0)
	
	# Apply circular shader
	var shader = load("res://circle_shader.gdshader")
	if shader:
		var material = ShaderMaterial.new()
		material.shader = shader
		player_figure.material = material
	
	add_child(player_figure)
	
	# Create other figures
	spawn_other_figures(3)

func spawn_other_figures(num_figures):
	for i in range(num_figures):
		var figure = ColorRect.new()
		figure.size = Vector2(40, 40)
		
		# Position away from player
		var pos_x = randf_range(100, 924)
		var pos_y = randf_range(150, 550)
		figure.position = Vector2(pos_x, pos_y)
		
		# Set color
		figure.color = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0))
		
		# Apply circular shader
		var shader = load("res://circle_shader.gdshader")
		if shader:
			var material = ShaderMaterial.new()
			material.shader = shader
			figure.material = material
		
		add_child(figure)
		other_figures.append({"node": figure, "target_x": pos_x, "target_y": pos_y, "speed": randf_range(0.5, 2.0)})

func process_loneliness_game(delta):
	# Move player with arrow keys
	if Input.is_action_pressed("ui_right"):
		player_figure.position.x += 2
	if Input.is_action_pressed("ui_left"):
		player_figure.position.x -= 2
	if Input.is_action_pressed("ui_down"):
		player_figure.position.y += 2
	if Input.is_action_pressed("ui_up"):
		player_figure.position.y -= 2
	
	# Keep player on screen
	player_figure.position.x = clamp(player_figure.position.x, 0, 1024 - player_figure.size.x)
	player_figure.position.y = clamp(player_figure.position.y, 0, 768 - player_figure.size.y)
	
	# Update other figures - move away from player
	for figure_data in other_figures:
		var figure = figure_data.node
		var player_center = player_figure.position + player_figure.size / 2
		var figure_center = figure.position + figure.size / 2
		
		var dir = figure_center.direction_to(player_center)
		
		# Move away if player gets close
		var distance = figure_center.distance_to(player_center)
		if distance < 150:
			# Set new target away from player
			var escape_dir = -dir
			figure_data.target_x = clamp(figure_center.x + escape_dir.x * 200, 50, 974)
			figure_data.target_y = clamp(figure_center.y + escape_dir.y * 200, 150, 550)
			
			# Count this as a connection attempt
			if distance < 60:
				connection_attempts += 1
				if connection_attempts % 3 == 0:
					loneliness_stage = min(loneliness_stage + 1, loneliness_messages.size() - 1)
					instruction_label.text = loneliness_messages[loneliness_stage]
		
		# Move toward target
		var target = Vector2(figure_data.target_x, figure_data.target_y)
		var move_dir = figure_center.direction_to(target)
		figure.position += move_dir * figure_data.speed
		
		# Get a new target if reached the current one
		if figure_center.distance_to(target) < 10:
			figure_data.target_x = randf_range(50, 974)
			figure_data.target_y = randf_range(150, 550)

func handle_loneliness_input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Move toward touch position
		var target = event.position
		var player_center = player_figure.position + player_figure.size / 2
		var dir = player_center.direction_to(target)
		player_figure.position += dir * 20

# SELF COMPASSION GAME IMPLEMENTATION
func setup_self_compassion_game():
	compassion_stage = 0
	failure_count = 0
	target_speed = 2.0
	instruction_label.text = compassion_messages[compassion_stage]
	
	# Create target
	target = ColorRect.new()
	target.size = Vector2(30, 30)
	target.position = Vector2(512 - 15, 384 - 15)
	target.color = Color(1.0, 0.0, 0.0)
	
	# Apply circular shader
	var shader = load("res://circle_shader.gdshader")
	if shader:
		var material = ShaderMaterial.new()
		material.shader = shader
		target.material = material
	
	add_child(target)
	
	# Create player cursor
	player_cursor = ColorRect.new()
	player_cursor.size = Vector2(20, 20)
	player_cursor.position = Vector2(512 - 10, 384 - 10)
	player_cursor.color = Color(0.0, 0.0, 1.0)
	
	# Apply circular shader
	if shader:
		var material = ShaderMaterial.new()
		material.shader = shader
		player_cursor.material = material
	
	add_child(player_cursor)

func process_self_compassion_game(delta):
	# Move target
	var time = Time.get_ticks_msec() / 1000.0
	target.position.x = 512 - 15 + sin(time * target_speed) * 200
	target.position.y = 384 - 15 + cos(time * target_speed * 0.7) * 150
	
	# Check if cursor is on target
	var target_center = target.position + target.size / 2
	var cursor_center = player_cursor.position + player_cursor.size / 2
	
	if target_center.distance_to(cursor_center) > 50:
		failure_count += 1
		if failure_count % 60 == 0:  # Check every second (assuming 60 fps)
			compassion_stage = min(compassion_stage + 1, compassion_messages.size() - 1)
			instruction_label.text = compassion_messages[compassion_stage]
			
			# Slow down target after certain stages
			if compassion_stage >= 4:
				target_speed = max(0.5, target_speed - 0.2)

func handle_self_compassion_input(event):
	if event is InputEventMouseMotion:
		# Move cursor to mouse position, but only when mouse is moved by the user
		if event.relative.length() > 0:
			player_cursor.position = event.position - player_cursor.size / 2

# OVERWHELMED GAME IMPLEMENTATION
func setup_overwhelmed_game():
	overwhelm_stage = 0
	tasks_attempted = 0
	instruction_label.text = overwhelm_messages[overwhelm_stage]
	
	# Create multiple task areas
	var task_width = 200
	var spacing = 40
	var start_x = (1024 - (task_width * 3 + spacing * 2)) / 2
	
	for i in range(3):
		var task = {"type": task_types[i], "node": null, "completed": false, "elements": []}
		
		# Create task area
		var task_area = ColorRect.new()
		task_area.size = Vector2(task_width, 150)
		task_area.position = Vector2(start_x + i * (task_width + spacing), 250)
		task_area.color = Color(0.2, 0.2, 0.2)
		add_child(task_area)
		task.node = task_area
		
		# Create task elements based on type
		match task.type:
			"sort":
				var task_label = Label.new()
				task_label.text = "Sort by color"
				task_label.position = Vector2(task_area.position.x + 10, task_area.position.y + 10)
				add_child(task_label)
				task.elements.append(task_label)
				
				# Create colored items to sort
				for j in range(5):
					var item = ColorRect.new()
					item.size = Vector2(20, 20)
					item.position = Vector2(
						task_area.position.x + 20 + j * 30, 
						task_area.position.y + 40
					)
					item.color = Color(randf_range(0, 1.0), randf_range(0, 1.0), randf_range(0, 1.0))
					add_child(item)
					task.elements.append(item)
			
			"count":
				var task_label = Label.new()
				task_label.text = "Count items"
				task_label.position = Vector2(task_area.position.x + 10, task_area.position.y + 10)
				add_child(task_label)
				task.elements.append(task_label)
				
				# Create items to count
				for j in range(randi() % 10 + 5):
					var item = ColorRect.new()
					item.size = Vector2(10, 10)
					item.position = Vector2(
						task_area.position.x + randf_range(10, task_width - 10),
						task_area.position.y + randf_range(40, 140)
					)
					item.color = Color.WHITE
					add_child(item)
					task.elements.append(item)
				
				# Create answer input
				var answer = LineEdit.new()
				answer.position = Vector2(task_area.position.x + 50, task_area.position.y + 100)
				answer.size = Vector2(100, 30)
				add_child(answer)
				task.elements.append(answer)
			
			"balance":
				var task_label = Label.new()
				task_label.text = "Keep balanced"
				task_label.position = Vector2(task_area.position.x + 10, task_area.position.y + 10)
				add_child(task_label)
				task.elements.append(task_label)
				
				# Create balance meter
				var meter = ColorRect.new()
				meter.size = Vector2(150, 20)
				meter.position = Vector2(task_area.position.x + 25, task_area.position.y + 70)
				meter.color = Color(0.5, 0.5, 0.5)
				add_child(meter)
				task.elements.append(meter)
				
				# Create slider indicator
				var indicator = ColorRect.new()
				indicator.size = Vector2(10, 30)
				indicator.position = Vector2(task_area.position.x + 95, task_area.position.y + 65)
				indicator.color = Color.RED
				add_child(indicator)
				task.elements.append(indicator)
				
				# Create buttons
				var left_btn = Button.new()
				left_btn.text = "<"
				left_btn.position = Vector2(task_area.position.x + 25, task_area.position.y + 100)
				left_btn.size = Vector2(40, 30)
				add_child(left_btn)
				task.elements.append(left_btn)
				
				var right_btn = Button.new()
				right_btn.text = ">"
				right_btn.position = Vector2(task_area.position.x + 135, task_area.position.y + 100)
				right_btn.size = Vector2(40, 30)
				add_child(right_btn)
				task.elements.append(right_btn)
		
		tasks.append(task)
	
	# Create noise particles
	for i in range(20):
		var particle = ColorRect.new()
		particle.size = Vector2(randf_range(5, 15), randf_range(5, 15))
		particle.position = Vector2(randf_range(0, 1024), randf_range(0, 768))
		particle.color = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0), 0.3)
		add_child(particle)
		noise_particles.append({"node": particle, "speed_x": randf_range(-2, 2), "speed_y": randf_range(-2, 2)})

func process_overwhelmed_game(delta):
	# Update noise particles
	for particle_data in noise_particles:
		var particle = particle_data.node
		particle.position.x += particle_data.speed_x
		particle.position.y += particle_data.speed_y
		
		# Wrap around screen
		if particle.position.x < -particle.size.x:
			particle.position.x = 1024
		elif particle.position.x > 1024:
			particle.position.x = -particle.size.x
			
		if particle.position.y < -particle.size.y:
			particle.position.y = 768
		elif particle.position.y > 768:
			particle.position.y = -particle.size.y
	
	# Update balance task
	for task in tasks:
		if task.type == "balance":
			# Move indicator randomly
			var indicator = task.elements[3]  # The indicator is at index 3
			indicator.position.x += randf_range(-1, 1)
			
			# Keep within bounds
			var meter = task.elements[2]  # The meter is at index 2
			var min_x = meter.position.x - indicator.size.x/2
			var max_x = meter.position.x + meter.size.x - indicator.size.x/2
			indicator.position.x = clamp(indicator.position.x, min_x, max_x)
	
	# Advance game stage periodically
	tasks_attempted += 1
	if tasks_attempted % 300 == 0:  # Every 5 seconds (assuming 60fps)
		overwhelm_stage = min(overwhelm_stage + 1, overwhelm_messages.size() - 1)
		instruction_label.text = overwhelm_messages[overwhelm_stage]

func handle_overwhelmed_input(event):
	# Handle task-specific inputs
	for task_idx in range(tasks.size()):
		var task = tasks[task_idx]
		if task.type == "balance" and task.elements.size() >= 6:  # Ensure we have enough elements
			var left_btn = task.elements[4]  # Left button is at index 4
			var right_btn = task.elements[5]  # Right button is at index 5
			var indicator = task.elements[3]  # Indicator is at index 3
			
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var left_rect = Rect2(left_btn.position, left_btn.size)
				var right_rect = Rect2(right_btn.position, right_btn.size)
				
				if left_rect.has_point(event.position):
					indicator.position.x -= 5
				elif right_rect.has_point(event.position):
					indicator.position.x += 5

func _input(event):
	if current_state != GameState.PLAYING:
		return
		
	if event is InputEventKey and event.pressed and event.keycode == KEY_BACKSPACE:
		# Call the same function that the back button uses
		_on_back_button_pressed()
		
	# Game-specific input handling
	match current_game:
		"BOREDOM":
			handle_boredom_input(event)
		"ANXIETY":
			handle_anxiety_input(event)
		"DEPRESSION":
			handle_depression_input(event)
		"LONELINESS":
			handle_loneliness_input(event)
		"SELF_COMPASSION":
			handle_self_compassion_input(event)
		"OVERWHELMED":
			handle_overwhelmed_input(event)
