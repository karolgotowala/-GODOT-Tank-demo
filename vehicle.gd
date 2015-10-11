extends VehicleBody

#GENERIC VARIABLES
var pi=3.1416#preloaded and shortened pi value
var pipi=6.2832#preloaded and shortened double pi value
#END OF GENERIC VARIABLES

#WHEEL VARIABLES
var track_thickness=0.5
#END OF WHEEL VARIABLES

#CAMERA VARIABLES
var min_camera_rotation=-50#minimum camera look angle
var max_camera_rotation=60#maximum camera look angle
#END OF CAMERA VARIABLES

#MOUSE INPUT VARIABLES
var tolerantion=128#tolerantion of touch input dispersion (usable in touch mode only, prevents 180 dgrees rotation when taping edges of screen)
#set me after touch input to 32 or 16 please
var window_size=Vector2()#window size variable
var last_x=0#last mouse position.x
var present_x=0#preent mouse position.x
var last_y=0#last mouse poition.y 
var present_y=0#present mouse position.y
#END OF MOUSE INPUT VARIABLES

#TURRET ROTATION VARIABLES
var rotation_x=0#calculated value to rotate camera along z axis a.k.a up and down look
var rotation_y=0#calculated value to rotate camera along y axis a.k.a left and right look
var camera_rotation=0#camera rotation of z axis a.k.a up and down look
var turret_rotation_helper=0#makes turret roatte faster or slower depending on hull rotation
var desired_turret_rotation=0#target rotation of turret 
var turret_speed=0.005#turret rotation speed
var base_rotation=0#rotation of hull
#END OF TURRET ROTATION VARIABLES

#RAY CASING VARIABLES
var collision_point_of_RayCast_2=Vector3(0,0,0)#point in space of rayvast collison of RayCast_2
var collision_point_of_RayCast_1=Vector3(0,0,0)#point in space of rayvast collison of RayCast_1
#END OF RAYCASTING VARIABLES

#HULL CONTROL VARIABLES
var rotation_speed=0.005#rotation speed of hull
var engine_force=400#default engine force
var in_turn_speed=12#maximum speed when cornering
var max_speed=30#maximum speed value
#END OF HULL CONTROL VARIABLES

#SPEED VARIABLES
var old_position=Vector3()#previous position
var new_position=Vector3()#actual position
var speed=0#speed value
var speed_vector=Vector3()#speed vector
#END OF SPEED VARIABLES

#SHOOTING VARIABLES
var shot_delay=30 #in frames
var may_i_shoot=0 #if reaches 0 then shooting is approved
var instanced_bullet=preload("res://bullet.scn")#preload of bullet object/scene containg a bullet object with script moving it forward
#END OF SHOOTING VARIABLES

#MAIN LOOP
func _fixed_process(delta):

#POSIITONING
	get_node("BODY/TURRET_CONTAINER/TURRET/CANNON").set_rotation(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera").get_rotation()*Vector3(1,1,1)+Vector3(-0.15,3.14,0))#setting rotation of cannon on z axis from  camera z axis

	get_node("TRACK_RIGHT/Armature/Skeleton").set_bone_pose(2,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("RIGHT_WHEEL_1").get_translation().y+track_thickness,0,0)))#assigning bone to RIGHT_WHEEL_1
	get_node("TRACK_RIGHT/Armature/Skeleton").set_bone_pose(0,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("RIGHT_WHEEL_2").get_translation().y+track_thickness,0,0)))#assigning bone to RIGHT_WHEEL_2
	get_node("TRACK_RIGHT/Armature/Skeleton").set_bone_pose(5,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("RIGHT_WHEEL_3").get_translation().y+track_thickness,0,0)))#assigning bone to RIGHT_WHEEL_3
	get_node("TRACK_RIGHT/Armature/Skeleton").set_bone_pose(1,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("RIGHT_WHEEL_4").get_translation().y+track_thickness,0,0)))#assigning bone to RIGHT_WHEEL_4
	get_node("TRACK_RIGHT/Armature/Skeleton").set_bone_pose(6,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("RIGHT_WHEEL_5").get_translation().y+track_thickness,0,0)))#assigning bone to RIGHT_WHEEL_5

	get_node("TRACK_LEFT/Armature/Skeleton").set_bone_pose(2,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("LEFT_WHEEL_1").get_translation().y+track_thickness,0,0)))#assigning bone to LEFT_WHEEL_1
	get_node("TRACK_LEFT/Armature/Skeleton").set_bone_pose(0,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("LEFT_WHEEL_2").get_translation().y+track_thickness,0,0)))#assigning bone to LEFT_WHEEL_2
	get_node("TRACK_LEFT/Armature/Skeleton").set_bone_pose(5,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("LEFT_WHEEL_3").get_translation().y+track_thickness,0,0)))#assigning bone to LEFT_WHEEL_3
	get_node("TRACK_LEFT/Armature/Skeleton").set_bone_pose(1,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("LEFT_WHEEL_4").get_translation().y+track_thickness,0,0)))#assigning bone to LEFT_WHEEL_4
	get_node("TRACK_LEFT/Armature/Skeleton").set_bone_pose(6,Transform(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),Vector3(-get_node("LEFT_WHEEL_5").get_translation().y+track_thickness,0,0)))#assigning bone to LEFT_WHEEL_5



#END OF POSITIONING

#CAMERA & TURRET ROTATION

	base_rotation=get_rotation().y#rotation of hull needed to calculate independent rotation of turret

#LIMITERS OF ROTATION TO KEEP ROTATION VALUES BETWEEN 0 TO 360 (needed for calculating fastet rotation direcion)
#done because ther is no loop rotation for example (270+180=450) and not (270+180=90) <= its hard to compute
#below rotations are represented in radians 
	if(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y>=pipi):#checks if rotation is bigger than 360 
		get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").set_rotation(Vector3(0,0,0))#resets rotation to 0
	if(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y<0):#checks if rotation is smaller than 0
		get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").set_rotation(Vector3(0,pipi,0))#sets rotation to 360

	if(desired_turret_rotation>=pipi):#checks if rotation is bigger than 360
		desired_turret_rotation=0#resets rotation to 0
	if(desired_turret_rotation<0):#checks if rotation is smaller than 0
		desired_turret_rotation=pipi#sets rotation to 360
#END OF LIMITERS OF ROTATION TO KEEP ROTATION VALUES BETWEEN 0 TO 360 (needed for calculating fastet rotation direcion)

#TURRET ROTATION
	if(abs(desired_turret_rotation-get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y)<pi):#checks angle between camera and turret
		if(desired_turret_rotation>get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y):#checks if its faster to rotate left
			desired_turret_rotation+=-turret_speed-turret_rotation_helper#rotates left
		if(desired_turret_rotation<get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y):#checks if its faster to rotate right
			desired_turret_rotation+=turret_speed-turret_rotation_helper#rotates right

	if(abs(desired_turret_rotation-get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y)>pi):#checks angle between camera and turret
		if(desired_turret_rotation>get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y):#checks if its faster to rotate left
			desired_turret_rotation+=turret_speed-turret_rotation_helper#rotates left
		if(desired_turret_rotation<get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation().y):#checks if its faster to rotate right
			desired_turret_rotation+=-turret_speed-turret_rotation_helper#rotates right

	get_node("BODY/TURRET_CONTAINER/TURRET").set_rotation(Vector3(0,desired_turret_rotation,0))#sets rotation to turret object
#END OF TURRET ROTATION

#MOUSE WARPING (for endles looking right or left)
	window_size=OS.get_window_size()#gets windows size
	
	if(get_viewport().get_mouse_pos().x>window_size.x-20):#checks if mouse reaches right border
		Input.warp_mouse_pos(Vector2(22,get_viewport().get_mouse_pos().y))#warps mouse position to left border keeping y axis
	if(get_viewport().get_mouse_pos().x<20):#checks if mouse reaches left border
		Input.warp_mouse_pos(Vector2(window_size.x-21,get_viewport().get_mouse_pos().y))#warps mouse position to right border keeping y axis

	if(get_viewport().get_mouse_pos().y>window_size.y-20):#checks i mouse reaches upper border
		Input.warp_mouse_pos(Vector2(get_viewport().get_mouse_pos().x,22))#warps mouse position to bottom border keeping x axis
	if(get_viewport().get_mouse_pos().y<20):#check if mouse reaches bottom border
		Input.warp_mouse_pos(Vector2(get_viewport().get_mouse_pos().x,window_size.y-21))#warps mouse position to upper border keeping x axis
#END OF MOUSE WARPING (for endles looking right or left)

#MOUSE MOVE CALCULATION
	present_y=get_viewport().get_mouse_pos().x#updates actual mouse postion on x axis
	present_x=get_viewport().get_mouse_pos().y#updates actual mouse position on y axis
	
	rotation_y=present_y-last_y#calculates needed rotation y
	rotation_x=present_x-last_x#calculates needed rotation x
#END OF MOUSE MOVE CALCULATION

#MOUSE MOVE TOLERNATION CALCULATIONS (only for touch input, so no "jumping" of mose occurs)
	if(rotation_y>0):#if +y precalculated rotation is done
		if(rotation_y>tolerantion):#checks if jump is not too high
			rotation_y=0#stop rotation
	if(rotation_y<0):#if -y precalculated rotation is done
		if(rotation_y<-tolerantion):#checks if jump is not too high
			rotation_y=0#stop rotation

	if(rotation_x>0):#if +x precalculated rotation is done
		if(rotation_x>tolerantion):#checks if jump is not too high
			rotation_x=0#stop rotation
	if(rotation_x<0):#if -x precalculated rotation is done
		if(rotation_x<-tolerantion):#checks if jump is not too high
			rotation_x=0#stop rotation
#END OF MOUSE MOVE TOLERNATION CALCULATIONS (only for touch input, so no "jumping" of mose occurs)

#SETTING STATES
	last_y=present_y#updates previous mouse position on y axis
	last_x=present_x#updates previous mouse position on x axis
	
	get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").set_rotation(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER").get_rotation()+Vector3(0,0-rotation_y*rotation_speed,0))#sets previously calculated rotation
	camera_rotation+=rotation_x#adds precalculated rotation to a helper variable
#END OF SETTING STATES

#CAMERA ROTATION ALONG Z AXIS (a.k.a look up or down)
	if(camera_rotation<max_camera_rotation and camera_rotation>min_camera_rotation):#checks rotation fits max and min values
		get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera").set_transform(Transform(Vector3(-1,0,0),Vector3(0,1,0+camera_rotation*rotation_speed),Vector3(0,0,-1),Vector3(0,5,-10)))#sets approved rotation
	elif(camera_rotation>max_camera_rotation):#checks for +  overrotating
		camera_rotation=max_camera_rotation#restores last approved rotation
	elif(camera_rotation<min_camera_rotation):#checks for - overrotating
		camera_rotation=min_camera_rotation#restores last approved rotation
	else:#checks for exception
		rotation_x=0#resets rotation during exception
#END OF CAMERA ROTATION ALONG Z AXIS (a.k.a look up or down)

#END OF CAMERA & TURRET ROTATION

#RAY CASING

#RAY CAST OF CROSS
	if(not get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera/RayCast_1").get_collider()==null):#if target is not null
		get_parent().get_node("Labels/targetLabel").set_text(str(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera/RayCast_1").get_collider().get_parent_spatial().get_name()))#getting target name
	else: #if target is null
		get_parent().get_node("Labels/targetLabel").set_text(" ")#clearing target label
	collision_point_of_RayCast_1=get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera/RayCast_1").get_collision_point()#gettin collision point of camera
	get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera/RayCast_1").set_rotation(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera/RayCast_1").get_parent().get_rotation()*Vector3(-1,1,1))#apllyng rotation of camera to ray cast making it paralel
#END OF RAY CAST OF CROSS

#RAY CAST OF CIRCLE
	get_parent().get_node("Labels/CROSSHAIR_CIRCLE").set_pos(get_viewport().get_camera().unproject_position(collision_point_of_RayCast_2)-Vector2(16,16))#setting position of 2d circle
	collision_point_of_RayCast_2=get_node("BODY/TURRET_CONTAINER/TURRET/RayCast_2").get_collision_point()#gettin colision point of turret
	get_node("BODY/TURRET_CONTAINER/TURRET/RayCast_2").set_rotation(get_node("BODY/CAMERA_CONTAINER_PARENT/CAMERA_CONTAINER/Camera").get_rotation()*Vector3(1,1,1))#applying rotation of camera to ray cast making it paralel
#END OF RAY CAST OF CIRCLE

#END OF RAY CASTING

#SHOOTING COUNTER
	if(may_i_shoot>0):
		may_i_shoot-=1
#END OF SHOOTING COUNTER

#SPEED COUNTER
	new_position=get_translation()#gets actual position
	speed_vector=old_position-new_position#calculates speed vector
	speed=sqrt(speed_vector.x*speed_vector.x+speed_vector.y*speed_vector.y+speed_vector.z*speed_vector.z)*200#calculates speed vector magnitude
	old_position=new_position#reloads pre-position														^*200 multiplied speed for better feel
	get_parent().get_node("Labels/speedLabel").set_text("SPEED="+str(round(speed)))#displays speed with rounding on the label element 
#END OF SPEED COUNTER

#FRAMES DISPLAYER
	get_parent().get_node("Labels/fpsLabel").set_text("FPS="+str(OS.get_frames_per_second()))#displaying frames per second by getting the data from engine
#END OF FRAMES DISPLAYER

#FIRING HANDLER
	if (Input.is_action_pressed("fire")):#on fire action
		if(may_i_shoot==0):#checking for fire permission
			may_i_shoot=shot_delay#resetting shooting counter
			var bullet = instanced_bullet.instance()#assinging pre-loaded bullet instance to a new variable
			bullet.set_transform(get_transform()*get_node("BODY").get_transform()*get_node("BODY/TURRET_CONTAINER").get_transform()*get_node("BODY/TURRET_CONTAINER/TURRET").get_transform()*get_node("BODY/TURRET_CONTAINER/TURRET/RayCast_2").get_transform())#placing not yet instanced bullet on start point of bullet trajectory
			get_parent().add_child(bullet)#instancing bullet obbject by adding it to a spatial 
#END OF FIRING HANDLER

#HULL CONTROL HANDLER

#MOVING BACKWARDS
	if (Input.is_action_pressed("down")):#on action down
		if(speed<max_speed):#limiting speed
			set_engine_force(-engine_force+100)#adding weakened by 1/4 force to engine 
		else:#if speed too high
			set_engine_force(0)#resetting force of engine
#END OF MOVING BACKWARDS

#MOVING FORWARD
	elif (Input.is_action_pressed("up")):#on action up
		if(speed<30):#limitng speed
			set_engine_force(engine_force)#adding force to engine
		else:#if speed too high
			set_engine_force(0)#resetting force of engine
	else:#on unaction up
		set_engine_force(0)#resetting force of engine
#END OF MOVING FORWARD

#ROTATING LEFT
	if (Input.is_action_pressed("left")):#on action left
		turret_rotation_helper=-rotation_speed*(4/(speed/10+2))#setting rotation parameter needed for turret rotation calculation
		get_node("BODY/CAMERA_CONTAINER_PARENT").rotate_y(rotation_speed*(4/(speed/10+2)))#rotate camera container contrary
		get_node("BODY/TURRET_CONTAINER").rotate_y(rotation_speed*(4/(speed/10+2)))#rotate turret contrary
		rotate_y(-rotation_speed*(4/(speed/10+2)))#rotating calculations for smooth feel
		if(speed>in_turn_speed):#checking for speed when cornering
			set_brake(15)#apllying braking when cornering
			set_engine_force(0)#resetting engine force when cornering
		else:#checking if not cornering
			set_brake(0)#resetting braking
#END OF ROTATING LEFT

#ROTATING RIGHT
	elif (Input.is_action_pressed("right")):#on action right
		turret_rotation_helper=rotation_speed*(4/(speed/10+2))#setting rotation parameter needed for turret rotation calculation
		get_node("BODY/CAMERA_CONTAINER_PARENT").rotate_y(-rotation_speed*(4/(speed/10+2)))#rotate camera container contrary
		get_node("BODY/TURRET_CONTAINER").rotate_y(-rotation_speed*(4/(speed/10+2)))#rotate turret contrary
		rotate_y(rotation_speed*(4/(speed/10+2)))#rotating calculations for smooth feel
		if(speed>in_turn_speed):#checking for speed when cornering
			set_brake(15)#apllying braking when cornering
			set_engine_force(0)#resetting engine force when cornering
		else:#checking if not cornering
			set_brake(0)#resetting braking
#END OF ROTATING RIGHT

#RESETTING PARAMETERS
	else:
		turret_rotation_helper=0#resetting rotation parameter needed for turret rotation calculation
		set_brake(0)#resetting braking
#END OF RESETTING PARAMETERS

#END OF HULL CONTROL HANDLER

#BRAKING HANDLER
	if (Input.is_action_pressed("brake")):#on action brake
		set_brake(40)#setting brake parametr of vechicle body
	else:#on unaction brake
		set_brake(0.0)#resetting brake parametr of vechicle body
#END OF BRAKING HANDLER

	pass
#END OF MAIN LOOP

#INPUT CATCHER
func _unhandled_input(event):
	get_parent().get_node("Labels/inputLabel").set_text(str(event))#input display on label element
	pass
#END OF INPUT CATCHER
	
#INITIALIZATION FUNCTION
func _ready():
	last_y=get_viewport().get_mouse_pos().x#setting initial value for touch input
	last_x=get_viewport().get_mouse_pos().y#setting initial value for touch input
	set_fixed_process(true)#enabling main loop
	set_process_unhandled_input(true)#enabling input catcher
	pass
#END OF INITIALIZATION FUNCTION


