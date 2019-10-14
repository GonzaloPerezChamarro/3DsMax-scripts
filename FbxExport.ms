
currentStateIndex = 1
staticMeshState  = #(true,false,false,false,false,false,false,false,false,false,false,false)
skeletalMeshState  = #(true,false,false,false,false,false,false,false,false,true,true,true)
animState  = #(false,false,false,false,false,false,false,true,true,false,true,true)

allStatesArray = #(staticMeshState, skeletalMeshState, animState)

--Tomas las opciones del usuario
function takeUserParameters arr = (
	
	arr[1] = fbxExport.smothing.checked
	arr[2] = fbxExport.split.checked  
	arr[3] = fbxExport.tangents.checked  
	arr[4] = fbxExport.turbosmooth.checked  
	arr[5] = fbxExport.instances.checked  
	arr[6] = fbxExport.selSets.checked  
	arr[7] = fbxExport.dummiesToBones.checked   
	arr[8] = fbxExport.anim.checked  
	arr[9] = fbxExport.bakeAnim.checked  
	arr[10] = fbxExport.deformations.checked  
	arr[11] = fbxExport.skins.checked  
	arr[12] = fbxExport.morpgs.checked 
	
	
)
--Actualiza los parametros de la UI
function updateParameters arr = (
	
	fbxExport.smothing.checked  = arr[1]
	fbxExport.split.checked  = arr[2]
	fbxExport.tangents.checked  = arr[3]
	fbxExport.turbosmooth.checked  = arr[4]
	fbxExport.instances.checked  = arr[5]
	fbxExport.selSets.checked  = arr[6]
	fbxExport.dummiesToBones.checked  = arr[7]
	fbxExport.anim.checked  = arr[8]
	fbxExport.bakeAnim.checked  = arr[9]
	fbxExport.deformations.checked  = arr[10]
	fbxExport.skins.checked  = arr[11]
	fbxExport.morpgs.checked  = arr[12]
)
-- Cmabia de modo SM/SK/A
function changeOptions mode = (
	
	takeUserParameters allStatesArray[currentStateIndex]
	
	currentStateIndex = fbxExport.modeSelection.state
	
	updateParameters allStatesArray[currentStateIndex]
	
	d = GetCurrentSelection()
	
	if d[1] != undefined and classOf d[1] == Dummy do (
		if(findString d[1].name "SM_" == 1 or findString d[1].name "SK_" == 1 or findString d[1].name "A_" == 1 ) do(
 
			newName = filterString d[1].name "_"
			changeName d[1] newName[2] currentStateIndex
		)
	)
)
--Cambia el nombre del dummy segun el nombre y el tipo de elemento
function changeName element nameElem assetType =(
	case assetType of(
		1: element.name = "SM_" + nameElem
		2: element.name = "SK_" +nameElem
		3: element.name = "A_" + nameElem
	)
)
-- Inicializa las opciones de la UI
function initializeOptions = (
	updateParameters allStatesArray[currentStateIndex]
)
-- Crea los dummies
function createAssetsFn= (
	
	objArr = #()
	for obj in GetCurrentSelection() do (
		if obj.parent == undefined then
			append objArr obj
	)
	
	dummyObjParent = Dummy()
	dummyGeo= Dummy name:"geo"
	dummyJoints = Dummy name:"joints"
	dummyRig = Dummy name:"rig"
	
	dummyRig.parent = dummyObjParent	
	dummyJoints.parent  = dummyObjParent
	dummyGeo.parent  = dummyObjParent
	
	case fbxExport.modeSelection.state of
	(
		1: dummyObjParent.name = "SM_" + objArr[1].name
		2: dummyObjParent.name ="SK_" + objArr[1].name
		3: dummyObjParent.name = "A_" +objArr[1].name
	)
	
	for o in objArr do (
		o.parent = dummyObjParent
	)
	
)
-- Obtiene la ruta del usuario
function takePath = (
	thePath = getSavepath initialDir:(GetDir #maxroot)
	fbxExport.route.text = thePath
)
--Selecciona todos los hijos de la seleccion actual
function selectAllChildren = (
	sel = GetCurrentSelection()
	i = 0
	while i < sel.count do (
		i += 1
		join sel sel[i].children
	)

	select sel
)
-- exportación de los assets
function exportAssets = (
	takeUserParameters allStatesArray[fbxExport.modeSelection.state]
	if fbxExport.route.text != "" then (
		dummies = GetCurrentSelection()
			for d in dummies do (
				if (findString d.name "SM_") == 1 then(
					for item in d.children do(
						if item.name == "geo" then(
							try(
								select item.children
								children = item.children
								geo = children
								item.children.parent = undefined
								selectAllChildren()
								exportSm d.name
								geo.parent = item
							)catch(
								print "Error en exportacion"
							)
						)
					)
				)
				if(findString d.name "SK_") == true then(
					geo = #{}
					joints = #{}
					for item in d.children do(
						if item.name == "geo" then(
							if item.children != undefined then(
								select item.children
								item.children.parent = undefined
								geo = selection as array
								deselect $*
							)
						)
						if item.name == "joints" then(
							if item.children != undefined then(
								select item.children
								item.children.parent = undefined
								joints = selection as array
								deselect $*
							)
						)
					)
					select geo
					selectMore joints
					
					selectAllChildren()
					
					exportSm d.name
					for item in d.children do(
						if (geo.count >= 1 and item.name == "geo") then(
							geo.parent = item
						)
						if(joints.count >= 1 and item.name == "joints" )then(
							joints.parent = item
						)
					)
				)
			
			if(findString d.name "A_") == true then(
				for item in d.children do(
					if item.name == "joints" then(
						select item.children
						joints = GetCurrentSelection()
						item.children.parent = undefined
						-- Bakear Animacion
						selectAllChildren()
						exportSm d.name
						joints.parent = item
					)
				)
			)
		)
	)
)
--exporta fbx con el nombre del archivo
function exportSm fileName= (
	--setExportSettings allStatesArray[1]
	
	completeFilePath = fbxExport.route.text + "\\" + fileName
	print "Path" + completeFilePath
	exportFile completeFilePath #noPrompt selectedOnly:true 
	
)
-- settea las opciones del usuario de exportacion
function setExportSettings = (
	
	states = undefined
	case fbxExport.modeSelection.state of(
		1: states = staticMeshState
		2: states = skeletalMeshState
		3: states = animState
	)
	
	FBXExporterSetParam "SmoothingGroups" staticMeshState[1]
	FBXExporterSetParam "NormalsPerPoly" staticMeshState[2]
	FBXExporterSetParam "TangentSpaceExport" staticMeshState[3]
	FBXExporterSetParam "SmoothMeshExport" staticMeshState[4]
	FBXExporterSetParam "Preserveinstances" staticMeshState[5]
	FBXExporterSetParam "SelectionSetExport" staticMeshState[6]
	FBXExporterSetParam "GeomAsBone" staticMeshState[7]
	FBXExporterSetParam "Animation" staticMeshState[8]
	FBXExporterSetParam "BakeAnimation" staticMeshState[9]
	FBXExporterSetParam "Deformations" staticMeshState[10]
	FBXExporterSetParam "Shape" staticMeshState[11]
	FBXExporterSetParam "Skin" staticMeshState[12]		
)
-- interfaz
rollout fbxExport "SuperToolExport" width:442 height:526
(
	label 'tittle' "FBX Export" pos:[192,16] width:55 height:16 align:#left
	button 'createButton' "Create Assets" pos:[16,40] width:408 height:56 align:#left
	groupBox 'grp1' "Asset Type" pos:[24,104] width:400 height:64 align:#left
	radioButtons 'modeSelection' "" pos:[72,136] width:301 height:16 labels:#("Static Mesh", "Skeletal Mesh", "Animation") columns:3 align:#left
	groupBox 'grp2' "Export Settings" pos:[24,184] width:400 height:232 align:#left
	checkbox 'smothing' "Smoothin Group" pos:[40,208] width:136 height:16 align:#left
	checkbox 'split' "Split per-vertex Normals" pos:[40,224] width:136 height:16 align:#left
	checkbox 'tangents' "Tangents and binormals" pos:[40,240] width:136 height:16 align:#left
	checkbox 'turbosmooth' "Turbosmooth" pos:[40,256] width:136 height:16 align:#left
	checkbox 'instances' "Preserve Instances" pos:[40,272] width:136 height:16 align:#left
	checkbox 'selSets' "Selection Sets" pos:[40,288] width:136 height:16 align:#left
	checkbox 'dummiesToBones' "Convert Deforming Dummies to bones" pos:[40,304] width:280 height:16 align:#left
	checkbox 'anim' "Animation" pos:[40,320] width:136 height:16 align:#left
	checkbox 'bakeAnim' "Bake Animation" pos:[40,336] width:136 height:16 align:#left
	checkbox 'deformations' "Deformations" pos:[40,352] width:136 height:16 align:#left
	checkbox 'skins' "Skins" pos:[40,368] width:136 height:16 align:#left
	checkbox 'morpgs' "Morphs" pos:[40,384] width:136 height:16 align:#left
	groupBox 'grp3' "Export Folder" pos:[24,424] width:400 height:40 align:#left
	editText 'route' "" pos:[32,440] width:336 height:16 align:#left
	button 'browse' "..." pos:[376,440] width:32 height:16 align:#left
	button 'exportButton' "Export" pos:[40,472] width:160 height:24 align:#left
	button 'saveButton' "Save Export Settings" pos:[224,472] width:184 height:24 align:#left
	
	on modeSelection changed state do changeOptions modeSelection.state
	on createButton pressed do createAssetsFn()
	
	on browse pressed do takepath()
	on exportButton pressed do exportAssets()
)
--Creacion de la interfaz e inicialización
createDialog fbxExport 
initializeOptions()




