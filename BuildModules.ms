delete $*
struct wallModule(name, height, width, length, obj);
struct windowModule(name, height, width, length, windowHeight, windowWidth, worldHeight, obj);
struct doorModule(name, height, width, length, doorWidth, doorHeight, obj);
------------------------------------------------------------------------------------------------------
--------------------------------------------PARTE 1-------------------------------------------------
------------------------------------------------------------------------------------------------------
function generateWall l w h widthSegs heightSegs name= (
	boxObj = Box name:name height: h width: w length: l widthsegs:widthSegs lengthSegs:1 heightsegs:heightSegs
	convertTo boxObj Editable_Poly
	
	vert = polyop.GetVert boxObj 3
	select boxObj
	selection.pivot = [vert.x, vert.y, vert.z]
		
	return boxObj
)

function generateWindow wallLength wallWidth wallHeight windowWidth windowHeight windowWorldHeight name= (

	wallTemp = generateWall wallLength wallWidth wallHeight 3 3 name
	select wallTemp
	
	subobjectLevel = 1
	vert = polyop.GetVert wallTemp 18
	disp = windowWorldHeight - vert.z
	polyop.MoveVert wallTemp #{17..24}[0,0,disp]
	
	vert = polyop.GetVert wallTemp 26
	vert2 = polyop.GetVert wallTemp 18
	disp = vert2.z - vert.z + windowHeight
	polyop.MoveVert wallTemp #{25..32}[0,0,disp]
	
	vert = polyop.GetVert wallTemp 18
	vert2 = polyop.GetVert wallTemp 19
	totalDisp = windowWidth - (vert2.x - vert.x)
	polyop.MoveVert wallTemp #{3, 7, 11, 15, 19, 22, 27, 30}[(totalDisp*0.5), 0,0]
	polyop.MoveVert wallTemp #{2, 6, 10, 14, 18, 23, 26, 31}[-(totalDisp*0.5), 0,0]
	
	subobjectLevel = 4
	$.EditablePoly.SetSelection #Face #{11,23}
	$.EditablePoly.delete #Face
	
	subobjectLevel = 3
	$.EditablePoly.SetSelection #Edge #{25, 28, 31..32, 47, 50, 52..53}
	$.bridgeSelected = 1
	$.EditablePoly.Bridge ()
	
	vert = polyop.GetVert wallTemp 5
	select wallTemp
	selection.pivot = [vert.x, vert.y, vert.z]
	return wallTemp
	
)

function generateDoor wallLength wallWidth wallHeight doorWidth doorHeight name = (

	wallTemp = generateWall wallLength wallWidth wallHeight 3 2 name
	select wallTemp
	
	subobjectLevel = 1
	vert = polyop.GetVert wallTemp 18
	disp = doorHeight - vert.z
	polyop.MoveVert wallTemp #{17..24}[0,0,disp]
	
	vert = polyop.GetVert wallTemp 18
	vert2 = polyop.GetVert wallTemp 19
	totalDisp = doorWidth - (vert2.x - vert.x)
	polyop.MoveVert wallTemp #{2, 6, 10, 14, 18, 23}[-(totalDisp*0.5), 0,0]
	polyop.MoveVert wallTemp #{3, 7, 11, 15, 19, 22}[(totalDisp*0.5), 0,0]
	
	subobjectLevel = 4
	$.EditablePoly.SetSelection #Face #{2,8,16}
	$.EditablePoly.delete #Face
	
	subobjectLevel = 2
	$.EditablePoly.SetSelection #Edge #{23, 36}
	$.bridgeSelected = 1
	$.EditablePoly.Bridge ()
	
	$.EditablePoly.SetSelection #Edge #{3, 5, 19, 22, 33, 35, 43..44}
	$.EditablePoly.capHoles #Edge
	
	vert = polyop.GetVert wallTemp 5
	select wallTemp
	selection.pivot = [vert.x, vert.y, vert.z]
	return wallTemp
)

rollout toolInterface "Modules Room Tool" width:732 height:705
(
	GroupBox 'grp1' "ModulesGenerator" pos:[17,65] width:700 height:335 align:#left
	GroupBox 'grp2' "Modify Room" pos:[15,579] width:700 height:106 align:#left
	GroupBox 'grp3' "Room Generator" pos:[15,413] width:700 height:153 align:#left
	button 'changeWindow' "Change to Window" pos:[54,620] width:247 height:51 align:#left
	button 'changeDoor' "Change to Door" pos:[384,620] width:247 height:51 align:#left
	listbox 'modulesList' "Modules" pos:[34,107] width:214 height:14 align:#left
	GroupBox 'grp4' "Wall" pos:[283,84] width:362 height:72 align:#left
	label 'lbl1' "Height" pos:[304,101] width:43 height:18 align:#left
	label 'lbl2' "Width" pos:[409,100] width:43 height:18 align:#left
	label 'lbl3' "Length" pos:[534,100] width:43 height:18 align:#left
	spinner 'wHeightSpin' "" pos:[304,121] width:66 height:16 range:[0,1000,250] align:#left
	spinner 'wWidthSpin' "" pos:[412,120] width:62 height:16 range:[0,1000,200] align:#left
	spinner 'wLengthSpin' "" pos:[529,119] width:56 height:16 range:[0,1000,30] align:#left
	GroupBox 'grp7' "Window" pos:[289,161] width:359 height:82 align:#left
	label 'lbl4' "Height" pos:[307,188] width:43 height:18 align:#left
	label 'lbl5' "Width" pos:[412,187] width:43 height:18 align:#left
	label 'lbl6' "Height(Floor)" pos:[528,186] width:103 height:18 align:#left
	spinner 'winHeightSpin' "" pos:[307,208] width:66 height:16 range:[0,1000,90] align:#left
	spinner 'winWidthSpin' "" pos:[415,207] width:62 height:16 range:[0,1000,60] align:#left
	spinner 'winHeightFloorSpin' "" pos:[532,206] width:56 height:16 range:[0,1000,110] align:#left
	GroupBox 'grp9' "Door" pos:[292,246] width:359 height:73 align:#left
	label 'lbl7' "Height" pos:[310,264] width:43 height:18 align:#left
	label 'lbl8' "Width" pos:[415,263] width:43 height:18 align:#left
	spinner 'dHeightSpin' "" pos:[311,284] width:66 height:16 range:[0,1000,210] align:#left
	spinner 'dWidthSpin' "" pos:[418,283] width:62 height:16 range:[0,1000,100] align:#left
	button 'addWallButton' "Add" pos:[656,92] width:50 height:64 align:#left
	button 'addWindowButton' "Add" pos:[656,174] width:50 height:64 align:#left
	button 'addDoorButton' "Add" pos:[656,255] width:50 height:64 align:#left
	button 'generateButton' "Generate Geomatry" pos:[231,338] width:245 height:50 align:#left
	listbox 'lbx2' "    --------- width ---------" pos:[102,439] width:170 height:7 align:#left
	label 'lbl12' "length" pos:[299,497] width:59 height:27 align:#left
	listbox 'lbx3' "" pos:[120,469] width:136 height:5 align:#left
	spinner 'roomWidthSpin' "" pos:[390,453] width:85 height:16 range:[0,1500,900] align:#left
	spinner 'roomLengthSpin' "" pos:[518,453] width:85 height:16 range:[0,1500,600] align:#left
	button 'createButton' "Create Room" pos:[510,522] width:152 height:33 align:#left
	
	on changeWindow pressed do
		changeToWindow()
	on changeDoor pressed do
		changeToDoor()
	on addWallButton pressed do
		createWallModule()
	on addWindowButton pressed do
		createWindowModule()
	on addDoorButton pressed do
		createDoorModule()
	on generateButton pressed do
		generateGeometry()
	on createButton pressed do
		createRoom()
	
)
createDialog toolInterface

modules = #()
wallModules = #()
windowModules = #()
doorModules = #()
corner = undefined

function refreshModulesListbox = (
	
	temp = #()
	for it in wallModules do (
		append temp it.name 
	)
	for it in windowModules do (
		append temp it.name 
	)
	for it in doorModules do (
		append temp it.name 
	)
	toolInterface.modulesList.items = temp
)

function refreshModulesList = (
	
	modules = #()
	join modules wallModules
	join modules windowModules
	join modules doorModules
	modules
)

function createWallModule = (
	h = toolInterface.wHeightSpin.value
	w = toolInterface.wWidthSpin.value
	l = toolInterface.wLengthSpin.value
	stringName = "Modulo de pared " + (wallModules.count+1)  as string
	newWall = wallModule name:stringName height: h width:w length:l obj:undefined
	
	append modules newWall
	append wallModules newWall
	refreshModulesList()
	refreshModulesListbox()
)

function createWindowModule = (
	if (toolInterface.modulesList.selection == 0  or not (isKindOf modules[toolInterface.modulesList.selection] wallModule)) then (
		print "Any wall selected"
	)
	else (
		h = modules[toolInterface.modulesList.selection].height
		w= modules[toolInterface.modulesList.selection].width
		l = modules[toolInterface.modulesList.selection].length
		stringName = modules[toolInterface.modulesList.selection].name + " con ventana de tipo " + (windowModules.count+1)   as string
		wHeight = toolInterface.winHeightSpin.value
		wWidth = toolInterface.winWidthSpin.value
		wHeightFloor = toolInterface.winHeightFloorSpin.value
		newWindow = windowModule name:stringName height:h width:w length:l windowHeight: wHeight windowWidth:wWidth worldHeight:wHeightFloor undefined

		append modules newWindow
		append windowModules newWindow
		refreshModulesList()
		refreshModulesListbox()
		
	)
	
)

function createDoorModule = (
	if (toolInterface.modulesList.selection == 0  or not (isKindOf modules[toolInterface.modulesList.selection] wallModule)) then (
		print "Any wall selected"
	)
	else (
		h = modules[toolInterface.modulesList.selection].height
		w= modules[toolInterface.modulesList.selection].width
		l = modules[toolInterface.modulesList.selection].length
		stringName = modules[toolInterface.modulesList.selection].name + " con puerta  de tipo " + (doorModules.count+1)  as string
		dHeight = toolInterface.dHeightSpin.value
		dWidth = toolInterface.dWidthSpin.value
		newDoor = doorModule name:stringName height:h width:w length:l doorWidth: dWidth doorHeight:dHeight undefined
		
		append modules newDoor
		append doorModules newDoor
		refreshModulesList()
		refreshModulesListbox()
	)
	
	
)

function addToModulesListbox moduleName = (
	temp = toolInterface.modulesList.items
	append temp moduleName
	toolInterface.modulesList.items = temp
)

function generateGeometry = (
	moduleIndex = 0
	xDistance = 300
	for item in modules do (
		if isKindOf item wallModule then (
			print "wall"
			item.obj = generateWall item.length item.width item.height 1 1 item.name
		)
		else if isKindOf item windowModule then (
			print "window"
			item.obj = generateWindow item.length item.width item.height item.windowWidth item.windowHeight item.worldHeight item.name
		)
		else if isKindOf item doorModule then (
			print "door"
			item.obj = generateDoor item.length item.width item.height item.doorWidth item.doorHeight item.name
		)
		else
			print "type error"
		
		
		obj = item.obj
		move obj [(xDistance * moduleIndex), -400, 0]
		
		moduleIndex+=1
	)
	box()
	corner = Box width: wallModules[1].length length: wallModules[1].length height: wallModules[1].height
	convertTo corner Editable_Poly
	vert = polyop.GetVert corner 3
	corner.pivot = [vert.x, vert.y, vert.z]
	move corner [(xDistance * moduleIndex), -400, 0]
	
)
------------------------------------------------------------------------------------------------------
-------------------------------------------- fin parte 1----------------------------------------------
------------------------------------------------------------------------------------------------------
--------------------------------------------PARTE 2-------------------------------------------------
------------------------------------------------------------------------------------------------------

function sortWallModulesList = (
	
	temp = 0
	for i = 1 to wallModules.count do 
	(
		for j = 1 to wallModules.count-1 do
		(
			if wallModules[j].width < wallModules[j+1].width do
			(
				temp = wallModules[j]
				wallModules[j] = wallModules[j+1]
				wallModules[j+1] = temp
			)	
		)
	)
)


function createRoom = (
	
	width = toolInterface.roomWidthSpin.value
	length = toolInterface.roomLengthSpin.value
	
	sortWallModulesList()

	resultWidth = 0
	resultLength = 0
	timesWidth = #()
	timesLength = #()
	
	i = 1
	while resultWidth != width and i<= wallModules.count do
	(
		index = i
		resultWidth = 0
		timesWidth = #()
		while (resultWidth < width and i <= wallModules.count) do
		(
			if timesWidth[i] == undefined  do timesWidth[i] = 0
			
			if (wallModules[i].width + resultWidth) <= width then 
			(
				resultWidth += wallModules[i].width
				timesWidth[i] += 1
			)
			else 
			(
				i +=1
			)
		)
		i = index
		i +=1
	)
	
	i = 1
	while resultLength != length and i<= wallModules.count  do 
	(
		index = i
		resultLength = 0
		timesLength = #()
		while (resultLength < length and i<= wallModules.count) do
		(
			
			if timesLength[i] == undefined  do timesLength[i] = 0
			
			if (wallModules[i].width + resultLength) <= length then 
			(
				resultLength += wallModules[i].width
				timesLength[i] += 1
			)
			else 
			(
				i +=1
			)
		)
		i = index
		i += 1
	)
	
	if (resultWidth != width) then
		print "Error en medida"
	else if resultLength != length then
		print "error 2"
	else
	(
		instanceWalls width length timesWidth timesLength
	)
)


function instanceWalls width length timesWidth timesLength = (
	
		
	widthWalls = #()
	lengthWalls = #()
	
	offsetWidth = [0,0,0]
		offsetLength = [0,0,0]
		for i = 1 to wallModules.count do
		(
			if timesWidth[i] == undefined do timesWidth[i] = 0
			if timesLength[i] == undefined do timesLength[i] = 0
			for j = 1 to timesWidth[i] do
			(
				nnl = instance wallModules[i].obj
				nnl.name = uniqueName "wall_instance" numDigits:2
				nnl.pos = offsetWidth
				append widthWalls nnl
				
				ins = instance wallModules[i].obj
				ins.name = uniqueName "wall_instance" numDigits:2
				ins.pos = widthWalls[1].pos - offsetWidth + [width,length,0]
				rotate ins (eulerangles 0 0 180)
				append widthWalls ins
				
				offsetWidth = [nnl.pos.x  + wallModules[i].width, nnl.pos.y , nnl.pos.z]
			)
		)
		
		for i = 1 to wallModules.count do
		(
			for k = 1 to timesLength[i] do
			(
				print "K"
				print k
				nnl = instance wallModules[i].obj
				nnl.name = uniqueName "wall_instance" numDigits:2
				nnl.pos = offsetWidth
				rotate nnl (eulerangles 0 0 90)
				append lengthWalls nnl
				
				ins = instance wallModules[i].obj
				ins.name = uniqueName "wall_instance" numDigits:2
				ins.pos = lengthWalls[1].pos - offsetWidth + [0,length,0]
				rotate ins (eulerangles 0 0 270)
				append lengthWalls ins
				
				offsetWidth = [nnl.pos.x, nnl.pos.y  + wallModules[i].width, nnl.pos.z]
			)
		)
		
		corner1 = instance corner
		corner2 = instance corner
		corner3 = instance corner
		corner4 = instance corner
		corner1.pos = widthWalls[1].pos + [width,0,0]
		corner2.pos =corner1.pos + [0,length,0]
		rotate corner2 (eulerangles 0 0 90)
		corner3.pos =corner2.pos + [-width,0,0]
		rotate corner3 (eulerangles 0 0 180)
		corner4.pos =corner3.pos + [0,-length,0]
		rotate corner4 (eulerangles 0 0 -90)
)

------------------------------------------------------------------------------------------------------
-------------------------------------------- fin parte 2----------------------------------------------
------------------------------------------------------------------------------------------------------
--------------------------------------------PARTE 3-------------------------------------------------
------------------------------------------------------------------------------------------------------
function changeToWindow = (

	width = 0
	if (GetCurrentSelection()).count == 0 then print "Nothing selected"
	else if (GetCurrentSelection()).count >1 then print"many objects selected"
	else
	(
		wallObject = (GetCurrentSelection())[1]
		dim = wallObject.max - wallObject.min
		if wallObject.rotation.z_rotation == 0 or wallObject.rotation.z_rotation ==-180 then
		(
			width = dim[1]
			print "dim1"
		)
		else
		(
			width = dim[2]
			print "dim2"
		)
		
		for i = 1 to windowModules.count do
		(
			print "fallo "
			print windowModules[i].width
			print width
			if windowModules[i].width == width do
			(
				print"changed to Window"
				nnl = instance windowModules[i].obj
				nnl.name = uniqueName "Window_instance" numDigits:2
				nnl.transform = wallObject.transform
				delete wallObject
				break;
			)
		)
	)
)

function changeToDoor = (

	width = 0
	if (GetCurrentSelection()).count == 0 then print "Nothing selected"
	else if (GetCurrentSelection()).count >1 then print"many objects selected"
	else
	(
		wallObject = (GetCurrentSelection())[1]
		dim = wallObject.max - wallObject.min
		if wallObject.rotation.z_rotation == 0 or wallObject.rotation.z_rotation == -180 then
		(
			width = dim[1]
		)
		else
		(
			width = dim[2]
		)
		
		for i = 1 to doorModules.count do
		(
			if doorModules[i].width == width do
			(
				print "changed to Door"
				nnl = instance doorModules[i].obj
				nnl.name = uniqueName "Door_instance" numDigits:2
				nnl.transform = wallObject.transform
				delete wallObject
				break;
			)
		)
	)
)









