

delete $*

sofaHeight = 40.0
sofaWidth = 120.0
sofaLength = 70.0

backHeight = 35.0
backWidth = 80.0
backLength = 15.0

armHeight = 15.0
armWidth = 20.0
armLength = 70.0



/*
((sofaWidth == backWidth + 2*armWidth and armLength < sofaLength) or
	(sofaWidth < backWidth + 2*armWidth and armLength < (sofaLength - backLength)))*/
	
	--(backWidth + 2*armWidth >= sofaWidth) and (backHeight >= armHeight)

if (backWidth + 2*armWidth >= sofaWidth) and (backHeight >= armHeight) 	then (
	sofa = Box height: sofaHeight width: sofaWidth length: sofaLength widthsegs:1 lengthsegs: 1
	convertTo sofa Editable_Poly
	
-- Connects laterales segun el respaldo
select $Box001
subobjectLevel = 2
$.EditablePoly.SetSelection #Edge #{2, 4..5, 7}
$.connectEdgeSegments = 2
$.EditablePoly.ConnectEdges ()
subobjectLevel = 1
vert1 = polyop.GetVert sofa 6
vert2 = polyop.GetVert sofa 14
disp = vert1.x - armWidth - vert2.x
polyop.MoveVert sofa #{10..11, 14..15}[disp,0,0]
polyop.MoveVert sofa #{9, 12..13, 16}[-disp,0,0]
	
	-- Connects intermedios laterales
	subobjectLevel = 2
$.EditablePoly.SetSelection #Edge #{2, 5, 16, 20,4, 7, 14, 18}
$.connectEdgeSegments = 1
$.connectEdgePinch = 0
$.EditablePoly.ConnectEdges ()

-- Connects inicio fondo segun respaldo
$.EditablePoly.SetSelection #Edge #{1, 3, 6, 8, 21..24, 37..40}
$.connectEdgeSegments = 2
$.EditablePoly.ConnectEdges ()

vert1 = polyop.GetVert sofa 15
vert2 = polyop.GetVert sofa 38
disp = vert1.y - backLength - vert2.y
polyop.MoveVert sofa #{26..27, 30..31, 33, 36, 38..39, 41, 44, 46..47}[0,disp,0]
polyop.MoveVert sofa #{25, 28..29, 32, 34..35, 37, 40, 42..43, 45, 48}[0,-disp,0]

if backWidth + 2*armWidth == sofaWidth then (
	if(armLength == sofaLength - 2*backLength) then (
		print "1 mode"
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
	else if(armLength == sofaLength - backLength) then (
		print "2 mode"
		
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 36, 37, 44, 45}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
	else if ( armLength < sofaLength - backLength) then (
		print "3 mode"
		subobjectLevel = 1
		pos1 = polyop.GetVert sofa 38
		pos2 = polyop.GetVert sofa 37
		displacementY =  pos1.y - armLength - pos2.y
		polyop.moveVert sofa #{25, 28..29, 32, 34..35, 37, 40, 42..43, 45, 48} [0, displacementY, 0]
		
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
		
		
	)else if(armLength > sofaLength - backLength and sofaLength != armLength) then (
		print "4 mode"
		subobjectLevel = 2
		$.EditablePoly.SetSelection #Edge #{3, 8, 21, 24, 37, 40, 46, 50, 56, 58, 64, 66}
		$.connectEdgeSegments = 1
		$.EditablePoly.ConnectEdges ()
		vert1 = polyop.GetVert sofa 30
		vert2 = polyop.GetVert sofa 56
		offset = armLength - (sofaLength - backLength)
		disp = offset - (vert2.y - vert1.y)
		polyop.MoveVert sofa #{49..60}[0,disp,0]
		
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35..38, 43..46, 48}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25,48}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
		
	)
	else if(sofaLength == armLength) do (
		print "4.1 mode"
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35..38, 43..46}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		$.EditablePoly.SetSelection #Face #{25}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
)
else if backWidth == sofaWidth then (
	if(armLength == sofaLength - 2*backLength) then (
		print "5 mode"
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35, 38, 43, 46}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25, 35, 38, 43, 46}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
	else if(armLength == sofaLength - backLength) then (
		print "6 mode"
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35..37, 38, 43..45, 46}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25, 35, 38, 43, 46}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
	else if ( armLength < sofaLength - backLength) do (
		print "7 mode"
		subobjectLevel = 1
		pos1 = polyop.GetVert sofa 38
		pos2 = polyop.GetVert sofa 37
		displacementY =  pos1.y - armLength - pos2.y
		polyop.moveVert sofa #{25, 28..29, 32, 34..35, 37, 40, 42..43, 45, 48} [0, displacementY, 0]
		
		subobjectLevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35, 38, 43, 46}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25, 35, 38, 43, 46}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
)
else if backWidth > sofaWidth - 2*armWidth then (
	subobjectLevel = 1
	vert1 = polyop.GetVert sofa 38
	vert2 = polyop.GetVert sofa 46
	offset = vert2.x - vert1.x
	disp = offset - (sofaWidth - backWidth)* 0.5 
	polyop.MoveVert sofa #{18, 20..21, 23, 41..42, 45..46}[disp,0,0]
	polyop.MoveVert sofa #{17, 19, 22, 24, 43..44, 47..48}[-disp,0,0]
	
	if(armLength == sofaLength - 2*backLength) then (
		print "8 mode"
		subobjectlevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35, 38}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25, 35, 38}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
	else if(armLength == sofaLength - backLength) then (
		print "9 mode"
		subobjectlevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35..38, 44..45}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25, 35, 38}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
	else if ( armLength < sofaLength - backLength) do (
		print "10 mode"
		subobjectLevel = 1
		pos1 = polyop.GetVert sofa 38
		pos2 = polyop.GetVert sofa 37
		displacementY =  pos1.y - armLength - pos2.y
		polyop.moveVert sofa #{25, 28..29, 32, 34..35, 37, 40, 42..43, 45, 48} [0, displacementY, 0]
		
		subobjectlevel = 4
		$.EditablePoly.SetSelection #Face #{9..10, 17..18, 25, 35, 38}
		$.faceExtrudeHeight = armHeight
		$.EditablePoly.buttonOp #Extrude
		
		$.EditablePoly.SetSelection #Face #{25, 35, 38}
		$.faceExtrudeHeight = (backHeight - armHeight)
		$.EditablePoly.buttonOp #Extrude
	)
)
else (
	print "Caso no encontrado"
)

-------------------------------------------------------------------------------------------
)
else (
	print "error"
)
	