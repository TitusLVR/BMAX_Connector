fn BMAX_Export fileName =
	(
		local expObjs = #()
		local expLights = #()
		local expCameras = #()
		local clonedObjs = #()
		local selectionNames = #()
		local BMAX_Exp_GlobalScale = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "GlobalScale" as float
		local BMAX_Exp_ConvertUnits = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "ConvertUnits_sys" as string
		local BMAX_Exp_UpAxis = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "UpAxis_sys" as string
		local BMAX_Exp_SmoothingGroups = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "SmoothingGroups" as booleanClass
		local BMAX_Exp_Preserveinstances = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "Preserveinstances" as booleanClass
		local BMAX_Exp_Cameras = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "Cameras" as booleanClass
		local BMAX_Exp_Lights = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "Lights" as booleanClass
		local BMAX_Exp_Animation = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "Animation" as booleanClass
		local BMAX_Exp_collapseStack = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "collapseStack" as booleanClass
		local BMAX_Exp_ResetXform = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "ResetXform" as booleanClass
		local BMAX_Exp_convertToPoly = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "convertToPoly" as booleanClass
		local BMAX_Exp_FBX_Ver = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "FBX_Version_sys" as string
		
		for n in selection do (append selectionNames n.name)
		
		maxOps.cloneNodes selection cloneType:#copy newNodes:&clonedObjs
		
		for i=1 to clonedObjs.count do
		(
			o = clonedObjs[i]
			o.name = selectionNames[i]
			if superClassOf o == geometryClass and ClassOf o != Targetobject then
			(	
				local objSnapshot = o
				if BMAX_Exp_collapseStack == True then (collapsestack objSnapshot)				
				if BMAX_Exp_ResetXform == True then (resetxform objSnapshot)
				if BMAX_Exp_convertToPoly == True then 
					(
						convertToPoly objSnapshot
						polyop.collapseDeadStructs objSnapshot
						objSnapshot.DeleteIsoMapVerts()
					)				
				append expObjs objSnapshot
			)
			
			if isKindOf o.baseObject Shape then 
			(				
				local splineSnapshot = o
				convertToPoly splineSnapshot								
				append expObjs splineSnapshot
			)
			
			if BMAX_Exp_Lights == True and superClassOf o == light then
			(
				if o.target != undefined then
					(
						target = o.target
						append expLights o
						append expLights target						
					)
					else
						(
							append expLights o
						)
			)
			
			if BMAX_Exp_Cameras == True and superClassOf o == camera then
			(
				if o.target != undefined then
					(
						target = o.target
						append expCameras o
						append expCameras target						
					)
					else
						(
							append expCameras o
						)				
			)
		)
		
		max select none
		select expObjs
		if expLights.count !=0 then selectmore expLights
		if expCameras.count !=0 then selectmore expCameras			
		
		if selection.count != 0 then
			(			
				pluginManager.loadClass FBXEXP
				--Geometry------------------------------------------------------------------------
				FBXExporterSetParam "SmoothingGroups" BMAX_Exp_SmoothingGroups
				FBXExporterSetParam "NormalsPerPoly" false
				FBXExporterSetParam "TangentSpaceExport" true
				FBXExporterSetParam "SmoothMeshExport" false
				FBXExporterSetParam "Preserveinstances" BMAX_Exp_Preserveinstances
				FBXExporterSetParam "SelectionSetExport" false
				FBXExporterSetParam "GeomAsBone" false
				FBXExporterSetParam "ColladaTriangulate" true
				FBXExporterSetParam "PreserveEdgeOrientation" false
				--Animation------------------------------------------------------------------------
				FBXExporterSetParam "Animation" BMAX_Exp_Animation
				--Cameras------------------------------------------------------------------------
				FBXExporterSetParam "Cameras" BMAX_Exp_Cameras
				--Lights------------------------------------------------------------------------
				FBXExporterSetParam "Lights" BMAX_Exp_Lights
				--Embed Media--------------------------------------------------------------------
				FBXExporterSetParam "EmbedTextures" false
				--Units----------------------------------------------------------------------------
				FBXExporterSetParam "ConvertUnit" BMAX_Exp_ConvertUnits
				FBXExporterSetParam "ScaleFactor" BMAX_Exp_GlobalScale
				--Axis Conversion-----------------------------------------------------------------
				FBXExporterSetParam "AxisConversionMethod" "None"
				FBXExporterSetParam "UpAxis" BMAX_Exp_UpAxis
				--UI----------------------------------------------------------------
				FBXExporterSetParam "ShowWarnings" false
				FBXExporterSetParam "GenerateLog" false
				--FBX File Format----------------------------------------------------------------
				FBXExporterSetParam "ASCII" false
				
				FBXExporterSetParam "FileVersion" BMAX_Exp_FBX_Ver
				
				-----------------------------------------------------------------------------------						
				exportFile fileName #noPrompt selectedOnly:true	usage:FBXEXP
				for n in expObjs do delete n
				max select none					
			)			
		else
			(
				messageBox "Selection is empty! Please select some Editable poly objects." title:"Warning" beep:off 
			)
	)
	
fn BMAX_Import fileName = 
	(		
		local BMAX_Imp_GlobalScale = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "GlobalScale" as float
		local BMAX_Imp_ConvertUnits = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ConvertUnits_sys" as string
		local BMAX_Imp_UpAxis = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "UpAxis_sys" as string
		local BMAX_Imp_SmoothingGroups = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "SmoothingGroups" as booleanClass
		local BMAX_Imp_ResetXForm = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ResetXForm" as booleanClass
		local BMAX_Imp_Cameras = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Cameras" as booleanClass
		local BMAX_Imp_Lights = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Lights" as booleanClass
		
		local BMAX_Imp_Animation = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Animation" as booleanClass
		local BMAX_Imp_BakeAnimationLayers = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "BakeAnimationLayers" as booleanClass
		local BMAX_Imp_FillTimeline = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FillTimeline" as booleanClass
		local BMAX_Imp_FilterKeyReducer = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FilterKeyReducer" as booleanClass
		local BMAX_Imp_FilterKeySync = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FilterKeySync" as booleanClass
		local BMAX_Imp_KeepFrameRate = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "KeepFrameRate" as booleanClass
		
		local BMAX_Imp_ImportBoneAsDummy = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ImportBoneAsDummy" as booleanClass
	    local BMAX_Imp_Markers = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Markers" as booleanClass
        local BMAX_Imp_PointCache = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "PointCache" as booleanClass
		local BMAX_Imp_Shape = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Shape" as booleanClass
		local BMAX_Imp_Skin = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Skin" as booleanClass

		local BMAX_Imp_RandomWireColor = getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireRandomColor" as booleanClass
		local BMAX_Imp_WireColor = (execute(getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireColor")) as color
		
		
		pluginManager.loadClass FBXIMP			
		FBXImporterSetParam "Mode" #create
		--Geometry------------------------------------------------------------------------
		FBXImporterSetParam "SmoothingGroups" BMAX_Imp_SmoothingGroups					
		--Animation------------------------------------------------------------------------
		FBXImporterSetParam "Animation" BMAX_Imp_Animation		
		FBXImporterSetParam "BakeAnimationLayers" BMAX_Imp_BakeAnimationLayers
		FBXImporterSetParam "FillTimeline" BMAX_Imp_FillTimeline
		FBXImporterSetParam "FilterKeyReducer" BMAX_Imp_FilterKeyReducer 
		FBXImporterSetParam "FilterKeySync" BMAX_Imp_FilterKeySync 
		FBXImporterSetParam "ImportBoneAsDummy" BMAX_Imp_ImportBoneAsDummy
		FBXImporterSetParam "KeepFrameRate" BMAX_Imp_KeepFrameRate		
		FBXImporterSetParam "Markers" BMAX_Imp_Markers			
		FBXImporterSetParam "PointCache" BMAX_Imp_PointCache						
		FBXImporterSetParam "Shape" BMAX_Imp_Shape
		FBXImporterSetParam "Skin" BMAX_Imp_Skin	
		--Cameras------------------------------------------------------------------------
		FBXImporterSetParam "Cameras" BMAX_Imp_Cameras
		--Lights------------------------------------------------------------------------
		FBXImporterSetParam "Lights" BMAX_Imp_Lights	
		--Units----------------------------------------------------------------------------
		FBXImporterSetParam "ConvertUnit" BMAX_Imp_ConvertUnits
		FBXImporterSetParam "ScaleFactor" BMAX_Imp_GlobalScale
		FBXImporterSetParam "ScaleConversion" True
		--Axis Conversion-----------------------------------------------------------------
		FBXImporterSetParam "AxisConversion" True
		FBXImporterSetParam "UpAxis" BMAX_Imp_UpAxis		
			
		importFile fileName #noprompt usage:FBXIMP
		
		
		B_Objs = for o in selection where (isKindOf o GeometryClass and canConvertTo o Editable_Mesh) collect o
		if B_Objs.count != 0 do
			(
				if BMAX_Imp_RandomWireColor then 
					(
						for o in B_Objs do o.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
					)
					else 
						(
							for o in B_Objs do (o.wirecolor = BMAX_Imp_WireColor)
						)
			
				if BMAX_Imp_ResetXForm == True do 
					(
						for o in B_Objs do
						( 
							resetxform o 
							convertToPoly o
						)
					)
			)		
	)	
	
fn BMAX_Init POS_X POS_Y = 
    (
        local theINIFile = "$userscripts\\BMAX\\bmax.ini"
        if doesFileExist theINIFile do
        (
            BMAX = getINISetting theINIFile "Path" "BMAX"
        )		
        if BMAX == "" OR BMAX == undefined do			
        (	
            BMAX = false
        )
        if BMAX == false do
        (
            local pickResult = getDirectories ((sysInfo.tempdir)+"\BMAX")
            if pickResult.count == 0 do 
            (			
                makeDir ((sysInfo.tempdir)+"\BMAX") all:False
                pickResult = getDirectories ((sysInfo.tempdir)+"\BMAX")
            )
            if pickResult[1] != undefined then
            (
                BMAX = pickResult[1] 
            )
            else
            (
                messagebox "There is no exchange folder. BMAX will now close."
                destroyDialog BMAX_Rollout
            )
            if BMAX != false then
            (
                setINISetting theINIFile "Path" "BMAX" BMAX
            )	
        )
        setDialogPos BMAX_Rollout [(POS_X),(POS_Y)]
        format "BMAX Connector: Script version:020 - loaded, have fun!!! \n"
        format "BMAX Connector: Working folder: %,  if you want to change folder - - - RightMouseButton DoubleClick on BMAX window - - -\n" BMAX	
    ) 

fn BMAX_Export_USD filename = 
	(		
		-- USD EXPORT
		local BMAX_USD_Exp_Meshes = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "Meshes" as booleanClass)
	    local BMAX_USD_Exp_Materials = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "Materials" as booleanClass)
		local BMAX_USD_Exp_Lights = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "Lights" as booleanClass)
		local BMAX_USD_Exp_Cameras = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "Cameras" as booleanClass)
		local BMAX_USD_Exp_FileFormat = execute(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "FileFormat_sys" as string)
		local BMAX_USD_Exp_Normals = execute(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "Normals_sys" as string)
		local BMAX_USD_Exp_UpAxis = execute(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "UpAxis_sys" as string)
		local BMAX_USD_Exp_BakeObjectOffsetTransform = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "BakeObjectOffsetTransform" as booleanClass)
		local BMAX_USD_Exp_PreserveEdgeOrientation = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export_USD" "PreserveEdgeOrientation" as booleanClass)
		
		
		-- set up the export options
		opts = USDExporter.CreateOptions()
		-- we can reset the options to ensure defaults are set
		opts.reset()
		-- .LogPath : string : Read|Write
		opts.LogPath = ((getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Path" "BMAX") + ("\BMAX_TMP_MAX.log"))
		-- LogLevel enums: {#off|#info|#warn|#error}
		opts.LogLevel = #error
		-- .Meshes : boolean : Read|Write
		opts.Meshes = BMAX_USD_Exp_Meshes
		-- .Materials : boolean : Read|Write
		opts.Materials = BMAX_USD_Exp_Materials
		-- .Lights : boolean : Read|Write
		opts.Lights = BMAX_USD_Exp_Lights
		-- .Cameras : boolean : Read|Write
		opts.Cameras = BMAX_USD_Exp_Cameras
		-- .FileFormat : enum : Read|Write
		-- FileFormat enums: {#ascii|#binary|#usdz}
		opts.FileFormat = BMAX_USD_Exp_FileFormat
		-- .Normals : enum : Read|Write
		-- Normals enums: {#none|#asAttribute|#asPrimvar}
		opts.Normals = BMAX_USD_Exp_Normals
		-- .UpAxis : enum : Read|Write
		-- UpAxis enums: {#y|#z}
		opts.UpAxis = BMAX_USD_Exp_UpAxis
		-- .BakeObjectOffsetTransform : boolean : Read|Write
		opts.BakeObjectOffsetTransform = BMAX_USD_Exp_BakeObjectOffsetTransform
		-- .PreserveEdgeOrientation : boolean : Read|Write
		opts.PreserveEdgeOrientation = BMAX_USD_Exp_PreserveEdgeOrientation
		
		-- unregister any callbacks:		
		opts.UnregisterCallbacks id:#exportcallback
		-- register a callback for successful export:
		fn exportcallback stageId conversionInfo filename options = (format "export succeeded stage:% conversionInfo:% " stageId conversionInfo)
		
		opts.RegisterCallback exportcallback #exportcallback #onExportComplete
		-- EXPORT
		-- ExportFile - no automatic redraw after invoked
		-- exportOptions default value: undefined
		-- contentSource enums: {#all|#selected|#nodeList}
		-- contentSource default value: #all
		-- nodeList default value: #()
		-- nodeList is In and Out parameter
		USDExporter.exportFile filename exportOptions:opts contentSource:#selected nodeList:#()
		-- unregister the callback:
		opts.UnregisterCallbacks id:#exportcallback	
	)

fn BMAX_Import_USD filename = 
	(
		-- USD import
		local BMAX_USD_Imp_InitialLoadSet = execute(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Import_USD" "InitialLoadSet_sys" as string)
		local BMAX_USD_Imp_MetaData = execute(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Import_USD" "MetaData_sys" as string)
		local BMAX_USD_Imp_TimeCode = execute(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Import_USD" "TimeCode_sys" as string)
		local BMAX_USD_Imp_TimeCodeValue = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Import_USD" "TimeCodeValue" as integer)
		local BMAX_USD_Imp_Materials = (getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Import_USD" "Materials" as booleanClass)
		-- set up the import options
		opts = USDImporter.CreateOptions()
		-- we can reset the options to ensure defaults are set
		opts.reset()
		-- .LogPath : string : Read|Write
		opts.LogPath = ((getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Path" "BMAX") + ("\BMAX_TMP_BLENDER.log"))
		-- LogLevel enums: {#off|#info|#warn|#error}
		opts.LogLevel = #error
		-- .InitialLoadSet : enum : Read|Write
		--  InitialLoadSet enums: {#loadAll|#loadNone}
		opts.InitialLoadSet = BMAX_USD_Imp_InitialLoadSet as string
		-- .Materials : boolean : Read|Write
		opts.Materials = BMAX_USD_Imp_Materials
		-- .StageMask : string array : Read|Write
		-- .MetaData : enum array : Read|Write
		-- MetaData enums: {#kind|#purpose|#hidden}
		opts.MetaData = BMAX_USD_Imp_MetaData
		-- .TimeCode : enum : Read|Write
		-- TimeCode enums: {#startTime|#endTime|#explicit}
		opts.TimeCode = BMAX_USD_Imp_TimeCode
		-- .TimeCodeValue : value : Read|Write
		opts.TimeCodeValue = BMAX_USD_Imp_TimeCodeValue

		-- unregister any callbacks:
		opts.UnregisterCallbacks id:#importcallback
		-- register a callback for successful import:
		fn importcallback stageId conversionInfo filename options = (format "import succeeded stage:% conversionInfo:% " stageId conversionInfo)
		opts.RegisterCallback importcallback #importcallback #onImportComplete
		
		-- IMPORT
		USDImporter.importFile filename importOptions:opts
		-- unregister the callback:
		opts.UnregisterCallbacks id:#importcallback	
	)