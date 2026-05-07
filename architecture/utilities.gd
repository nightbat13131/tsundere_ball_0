class_name UTILITIES extends RefCounted

enum Z_Indexes { BALL_PLAYER = 10, BALL_NPC = 9 , TRAPS = 5 , IN_TRAP = 4 , GROUND = 3, OVERLAY = 20}


const LOCKED_COLOR = Color.WEB_GRAY

const SHADER_MODULATE_COLOR = 'modulate'
const SHADER_OUTLINE_COLOR = 'new_background'

const COLOR_NPC_RED = Color("#f72796") # Color.RED
const COLOR_NPC_YELLOW = Color("#15e445") # Color.YELLOW
const COLOR_NPC_BLUE = Color("#23c8fa") # Color.BLUE
const COLOR_PLAYER = Color("#d8a4ec") #Color.WHITE
const DARKEN_HOLE = .25

const COLOR_BORDER_BOUNCY = Color.WHITE
const COLOR_BORDER_OBSTICAL = Color.BLACK
const COLOR_BORDER_NON_ENTITIY = Color.TRANSPARENT


static func get_square_points(half_side_leng: float) -> Array[Vector2]:
	var points: Array[Vector2] = [Vector2(1,1)*half_side_leng, Vector2(1,-1)*half_side_leng, Vector2(-1,-1)*half_side_leng, Vector2(-1,1)*half_side_leng]
	points.append(points[0])
	return points
