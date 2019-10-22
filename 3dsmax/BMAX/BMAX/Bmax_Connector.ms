--BMAX script version.010
try(destroydialog BMAX_Rollout)catch()
rollout BMAX_Rollout "BMAX Connector" 
(
	groupBox grp1 "Import/Export:" pos:[2,2] width:156 height:124 align:#left
	button btn_1 "Send to Blender"  pos:[8,40] width:144 height:40 align:#left tooltip:"Export model to Blender"
	button btn_2 "Get from Blender" pos:[8,80] width:144 height:40 align:#left tooltip:"Import model from Blender"
	spinner spn_1 "Global scale     " pos:[8,20] range:[0,1000000.0,(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "GlobalScale" "Scale" as float)] type:#float fieldWidth:60 toolTip:"Import/Export Global Scale" pos:[7,35]	
	
	groupBox grp2 "Add modifiers:" pos:[2,130] width:156 height:80 align:#left	
	checkbox ckb_1 " TurnToPoly" pos:[8,150] checked:(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "TurnToPoly" as booleanClass) tooltip:"Add TurnToPoly modifier after import"
	checkbox ckb_2 " Smooth" pos:[8,170] checked:(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "Smooth" as booleanClass) tooltip:"Add Smooth modifier after import"
	spinner spn_2 "" pos:[95,170] range:[0,180.0,(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "SmoothAngle" as float)] tooltip:"AutoSmooth" type:#float fieldWidth:45 scale:1
	checkbox ckb_3 " Convert to Poly" pos:[8,190] checked:(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "ConvertToPoly" as booleanClass) tooltip:"Convert to EditablePoly.Collapse stack."
	
	
	
	local BMAX_posX =  getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Position" "PosX" as float 	
	local BMAX_posY =  getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Position" "PosY" as float	
	local MaxVer = ((maxVersion())[1])	  
	local BMAX_INI = "$userscripts\\BMAX\\bmax.ini"	
	
	fn BMAX_Units = 
	(
		local unitsSysType = units.SystemType
		unit = #()
		unit = case unitsSysType of
			(
				(#inches):#("in",1) 
				(#feet):#("ft",1)
				(#miles):#("mi",1)
				(#millimeters):#("dm",0.001)
				(#centimeters):#("cm",0.01)
				(#meters):#("m",1)
				(#kilometers):#("km", 10)
			) 	 		
	)
	
	fn BMAX_Export fileName =
	(
		local expObjs = #()
		local BMAX_GlobalScale = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "GlobalScale" "Scale" as float
		expObjs = for o in selection where (isKindOf o.baseObject editable_poly) collect o
		--max select none
		for o in expObjs do 
			(			  
			  polyop.collapseDeadStructs o
			  o.DeleteIsoMapVerts()				
			)
		select expObjs
		
		if expObjs.count != 0 then
			(			
				pluginManager.loadClass FBXEXP
				--Geometry------------------------------------------------------------------------
				FBXExporterSetParam "SmoothingGroups" true
				FBXExporterSetParam "NormalsPerPoly" false
				FBXExporterSetParam "TangentSpaceExport" true
				FBXExporterSetParam "SmoothMeshExport" false
				FBXExporterSetParam "Preserveinstances" false
				FBXExporterSetParam "SelectionSetExport" false
				FBXExporterSetParam "GeomAsBone" false
				FBXExporterSetParam "ColladaTriangulate" true
				FBXExporterSetParam "PreserveEdgeOrientation" false
				--Animation------------------------------------------------------------------------
				FBXExporterSetParam "Animation" false
				--Cameras------------------------------------------------------------------------
				FBXExporterSetParam "Cameras" false
				--Lights------------------------------------------------------------------------
				FBXExporterSetParam "Lights" false
				--Embed Media--------------------------------------------------------------------
				FBXExporterSetParam "EmbedTextures" false
				--Units----------------------------------------------------------------------------
				FBXExporterSetParam "ConvertUnit" ((BMAX_Units())[1])
				FBXExporterSetParam "ScaleFactor" BMAX_GlobalScale
				--Axis Conversion-----------------------------------------------------------------
				FBXExporterSetParam "AxisConversionMethod" "None"
				FBXExporterSetParam "UpAxis" "Y" 
				--UI----------------------------------------------------------------
				FBXExporterSetParam "ShowWarnings" false
				FBXExporterSetParam "GenerateLog" false
				--FBX File Format----------------------------------------------------------------
				FBXExporterSetParam "ASCII" false
				if  MaxVer < 14000 then 
				(
					FBXExporterSetParam "FileVersion" "FBX200600"
				)		
				else 
					(
						case MaxVer of 
						(
							-- 3dsmax2018
							20000: (
									FBXExporterSetParam "FileVersion" "FBX201800"
									)
							-- 3dsmax2017
							19000: (
									FBXExporterSetParam "FileVersion" "FBX201700"
									)
							-- 3dsmax2016
							18000: (
									FBXExporterSetParam "FileVersion" "FBX201600"
									)
							-- 3dsmax2015
							17000: (
									FBXExporterSetParam "FileVersion" "FBX201500"
									)
							-- 3dsmax2014
							16000: (
									FBXExporterSetParam "FileVersion" "FBX201400"
									)
							-- 3dsmax2013
							15000: (
									FBXExporterSetParam "FileVersion" "FBX201300"
									)
							-- 3dsmax2012
							14000: (
									FBXExporterSetParam "FileVersion" "FBX201200"
									)				
						)		
					)
				-----------------------------------------------------------------------------------						
				exportFile fileName #noPrompt selectedOnly:true	usage:FBXEXP			
			)			
		else
			(
				messageBox "Selection is empty! Please select some Editable poly objects." title:"Warning" beep:off 
			)
	)
	
	fn BMAX_Import fileName = 
	(
		local BMAX_GlobalScale = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "GlobalScale" "Scale" as float	
		local BMAX_TurnToPoly = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "TurnToPoly" as booleanClass	
		local BMAX_Smooth = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "Smooth" as booleanClass
		local BMAX_SmoothAngle = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "SmoothAngle" as float		
		local BMAX_ConvertToPoly = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "ConvertToPoly" as booleanClass	
		
		pluginManager.loadClass FBXIMP			
		FBXImporterSetParam "Mode" #create
		--Geometry------------------------------------------------------------------------
		FBXImporterSetParam "SmoothingGroups" false					
		--Animation------------------------------------------------------------------------
		FBXImporterSetParam "Animation" false		
		FBXImporterSetParam "BakeAnimationLayers" false
		FBXImporterSetParam "FillTimeline" false
		FBXImporterSetParam "FilterKeyReducer" false	
		FBXImporterSetParam "FilterKeySync" false
		FBXImporterSetParam "ImportBoneAsDummy" false
		FBXImporterSetParam "KeepFrameRate" false		
		FBXImporterSetParam	"Markers" false			
		FBXImporterSetParam "PointCache" false						
		FBXImporterSetParam "Shape" false	
		FBXImporterSetParam "Skin" false	
		--Cameras------------------------------------------------------------------------
		FBXImporterSetParam "Cameras" false
		--Lights------------------------------------------------------------------------
		FBXImporterSetParam "Lights" false	
		--Units----------------------------------------------------------------------------
		FBXImporterSetParam "ConvertUnit" ((BMAX_Units())[1])
		FBXImporterSetParam "ScaleFactor" BMAX_GlobalScale
		FBXImporterSetParam "ScaleConversion" True
		--Axis Conversion-----------------------------------------------------------------
		FBXImporterSetParam "AxisConversion" false
		FBXImporterSetParam "UpAxis" "Z"		
			
		importFile fileName #noprompt usage:FBXIMP
		
		
		B_Objs = for o in selection where (isKindOf o GeometryClass and canConvertTo o Editable_Mesh) collect o
		if B_Objs.count != 0 do
		(
			for o in B_Objs do (o.wirecolor = (color 0 0 0))
			if BMAX_TurnToPoly == True do
			(
				for o in B_Objs do 
				(
					addModifier o (Turn_to_Poly())
				)
			)
			if BMAX_Smooth == true do
			(
				if BMAX_SmoothAngle == 0 then
				(
					for o in B_Objs do 
					(
						addModifier o (Smooth())
						--for m in o.modifiers where classof m == Smooth do (m.smoothingBits = 1)
						o.modifiers[#Smooth].smoothingBits = 1
					)
				)
				else
				(
					for o in B_Objs do 
					(
						addModifier o (Smooth())
						--for m in o.modifiers where classof m == Smooth do (m.smoothingBits = 1)
						o.modifiers[#Smooth].autosmooth = true
						o.modifiers[#Smooth].preventIndirect = false
						o.modifiers[#Smooth].threshold = getINISetting  ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "SmoothAngle" as float
						
					)					
				)
			)
			if BMAX_ConvertToPoly == True do
			(
				for o in B_Objs do 
				(
					convertToPoly o
				)
			)
		)
		
	)	
	
	fn BMAX_Init = 
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
		setDialogPos BMAX_Rollout [(BMAX_posX),(BMAX_posY)]
		format "BMAX Connector: Loaded, have fun!!! \n"
		format "BMAX Connector: Working folder: %,\n" BMAX	
	) 
	
	on BMAX_Rollout open do 
	(
		BMAX_Init()	
	)	
		
	on btn_1 pressed do 		
	(
		 
		BMAX_Export ((getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Path" "BMAX") + ("\BMAX_TMP_MAX.fbx"))	
	)

	on btn_2 pressed do 
	(
		 	
		BMAX_Import ((getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Path" "BMAX") + ("\BMAX_TMP_BLENDER.fbx"))		
	)
	
	on spn_1 changed val do 
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "GlobalScale" "Scale" ((spn_1.value) as string)							
	)
	
	on ckb_1 changed state do 
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "TurnToPoly" ((ckb_1.state) as string)							
	)
	
	on ckb_2 changed state do 
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "Smooth" ((ckb_2.state) as string)							
	)
	
	on spn_2 changed val do
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "SmoothAngle" ((spn_2.value) as string)							
	)
	
	on ckb_3 changed state do 
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "PostOPS" "ConvertToPoly" ((ckb_3.state) as string)							
	)
	
	
	on BMAX_Rollout close do 
	(	
		NewWinPos = getDialogpos BMAX_Rollout		
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Position" "PosX" ( (NewWinPos[1]  as integer ) as string)
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Position" "PosY" ( (NewWinPos[2]  as integer ) as string)		
		format "BMAX Connector: Closed!\n"
	)
	on BMAX_Rollout rbuttondblclk val do
	(
		BMAX = getINISetting BMAX_INI "Path" "BMAX"
		newFolder = getSavePath caption:"Custom BMAX exchange folder" initialDir:BMAX
		if newFolder != undefined then
			(
				setINISetting BMAX_INI "Path" "BMAX" newFolder 
			)
			else 
			(
				setINISetting BMAX_INI "Path" "BMAX" ((sysInfo.tempdir)+"BMAX")
				messageBox "Default path restored" title:"Warning" beep:off	
			)			
	)
)

createDialog BMAX_Rollout 160 215 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)


