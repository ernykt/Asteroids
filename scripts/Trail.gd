extends Line2D

var MAX_LENGTH = 200
var queue : Array
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = Globals.pos
	queue.push_front(pos)
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)
