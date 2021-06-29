--BMAX script version.016
--BMAX ver.017: Added preserve instances
--BMAX ver.018: Added ResetXForm on import and rest ofFBX import parameters
--BMAX ver.019: Script Reshuffle, added import/export macroses
--BMAX ver.020: Added random wirecolor or fixed
try(destroydialog BMAX_Rollout)catch()
rollout BMAX_Rollout "BMAX Connector" 
(

	groupBox grp1 "Import/Export:" pos:[2,2] width:156 height:108 align:#left
	button btn_1 "Send to Blender"  pos:[8,20] width:144 height:40 align:#left tooltip:"Export model to Blender"
	button btn_2 "Get from Blender" pos:[8,60] width:144 height:40 align:#left tooltip:"Import model from Blender"
	
	subrollout prefs_frame "Preferences" height:715 width:156 pos:[2,115]	
	
	local BMAX_posX =  getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Position" "PosX" as float 	
	local BMAX_posY =  getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Position" "PosY" as float	
	local MaxVer = ((maxVersion())[1])	  
	local BMAX_INI = "$userscripts\\BMAX\\bmax.ini"	
	
	include "$userscripts\\BMAX\\Bmax_Functions.ms"
	
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
rollout BMAX_PREFS_Rollout "Preferences" rolledUp: True
(	
	groupBox grp_export "Export:" pos:[2,2] width:140 height:253 align:#left
	spinner spn_e_globalScale "Global scale:" pos:[15,20] range:[0,1000000.0,(getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "GlobalScale" as float)] type:#float fieldWidth:50 toolTip:"Import/Export Global Scale" 
	label lbl_e_convertUnits "ConvertUnits:" pos:[9,44]
	dropdownlist dd_e_convertUnits "" pos:[78,40] items:#("mm", "cm", "dm", "m", "km", "in", "ft", "mi", "yd") selection:(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Export" "ConvertUnits" as integer) width: 59	 height:16	toolTip:"System units"
	label lbl_e_upAxis "UpAxis:" pos:[39,68]
	dropdownlist dd_e_upAxis "" pos:[78,65] items:#("Y", "Z") selection:(getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "UpAxis" as integer) width: 59  height:16 tooltip:"Y or Z"
	label lbl_e_fbx_ver "FBX:" pos:[25,94]
	dropdownlist dd_e_fbx_ver "" pos:[52,90] items:#("FBX201200", "FBX201300", "FBX201400", "FBX201600", "FBX201800", "FBX201900", "FBX202000", "FBX202100") selection:(getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "FBX_Version" as integer) width:85  height:16 tooltip:"Select FBX format version. Blender is using FBX Version 7.1 or newer.(FBX 2014)"
	
	checkbox ckb_e_smoothingGroups " Smoothing groups" pos:[9,115] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "SmoothingGroups") as booleanClass) tooltip:"Use smoothing groups, mark sharp edges in blender" 
	checkbox ckb_e_preserveInstances "Preserve instances" pos:[9,135] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Preserveinstances") as booleanClass) tooltip:"Preserve instances" 
	checkbox ckb_e_cameras "Cameras" pos:[9,155] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Cameras") as booleanClass) tooltip:"Export cameras"
	checkbox ckb_e_lights "Lights" pos:[80,155] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Lights") as booleanClass) tooltip:"Export lights"
	checkbox ckb_e_animation "Animation" pos:[9,175] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Animation") as booleanClass) tooltip:"Export animation"
	checkbox ckb_e_collapseStack "Mod.Collapse" pos:[9,195] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "collapseStack") as booleanClass) tooltip:"Collapse modifiers stack"
	checkbox ckb_e_resetXform "ResetXForm" pos:[9,215] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "ResetXform") as booleanClass) tooltip:"Apply transformation matrix = resetXform"
	checkbox ckb_e_convertToPoly "ConvertToPoly" pos:[9,235] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "convertToPoly") as booleanClass) tooltip:"Convert object to editable poly and delete deadVerts and deadStructs(some kind of cleanup)"
	
	groupBox grp_import "Import:" pos:[2,255] width:140 height:432 align:#left	
	spinner spn_i_globalScale "Global scale:" pos:[15,275] range:[0,1000000.0,(getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "GlobalScale" as float)] type:#float fieldWidth:50 toolTip:"Import/Export Global Scale" 
	label lbl_i_convertUnits "ConvertUnits:" pos:[9,295]
	dropdownlist dd_i_convertUnits "" pos:[78,295] items:#("mm", "cm", "dm", "m", "km", "in", "ft", "mi", "yd") selection:(getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Import" "ConvertUnits" as integer) width: 59 height:16 toolTip:"System units"
	label lbl_i_upAxis "UpAxis:" pos:[39,320]
	dropdownlist dd_i_upAxis "" pos:[78,320] items:#("Y", "Z") selection:(getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "UpAxis" as integer) width: 59  height:16	tooltip:"Y or Z"
	
	colorpicker colorpicker_i_wireColor "Wireframe Color" pos:[9,345] color:(execute (getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireColor")) alpha:false fieldWidth:46 height:18 title:"BMAX-IMPORT-Wireframe Color" toolTip:"Wireframe color for imported objects" enabled:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireColorEnabled") as booleanClass) 
	
	checkbox ckb_i_wireColorRandom "Random wire color" pos:[9,365] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireRandomColor") as booleanClass) tooltip:"Use random wire color"	
	
	checkbox ckb_i_smoothingGroups "Smoothing groups" pos:[9,385] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "SmoothingGroups") as booleanClass) tooltip:"Disabled - import with custom normals.\nEnabled - import with smoothing groups"	
	checkbox ckb_i_ResetXForm "ResetXForm" pos:[9,405] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ResetXForm") as booleanClass) tooltip:"Reset transformation matrix for imported object(s)."	
	checkbox ckb_i_cameras "Cameras" pos:[9,425] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Cameras") as booleanClass) tooltip:"Import cameras"
	checkbox ckb_i_lights "Lights" pos:[9,445] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Lights") as booleanClass) tooltip:"Import lights"
	checkbox ckb_i_animation "Animation" pos:[9,465] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Animation") as booleanClass) tooltip:"Import animation"	
	checkbox ckb_i_BakeAnimationLayers "BakeAnimationLayers" pos:[9,485] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "BakeAnimationLayers") as booleanClass) tooltip:"BakeAnimationLayers"
	checkbox ckb_i_FillTimeline "FillTimeline" pos:[9,505] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FillTimeline") as booleanClass) tooltip:"FillTimeline"
	checkbox ckb_i_FilterKeyReducer "FilterKeyReducer" pos:[9,525] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FilterKeyReducer") as booleanClass) tooltip:"FilterKeyReducer"
	checkbox ckb_i_FilterKeySync "FilterKeySync" pos:[9,545] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FilterKeySync") as booleanClass) tooltip:"FilterKeySync"
	checkbox ckb_i_KeepFrameRate "KeepFrameRate" pos:[9,565] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "KeepFrameRate") as booleanClass) tooltip:"KeepFrameRate"
	checkbox ckb_i_ImportBoneAsDummy "ImportBoneAsDummy" pos:[9,585] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ImportBoneAsDummy") as booleanClass) tooltip:"ImportBoneAsDummy"
	checkbox ckb_i_Markers "Markers" pos:[9,605] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Markers") as booleanClass) tooltip:"Markers"
	checkbox ckb_i_PointCache "PointCache" pos:[9,625] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "PointCache") as booleanClass) tooltip:"PointCache"
	checkbox ckb_i_Shape "Shape" pos:[9,645] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Shape") as booleanClass) tooltip:"Shape"	
	checkbox ckb_i_Skin "Skin" pos:[9,665] checked:((getINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Skin") as booleanClass) tooltip:"Skin"
	
	
	on BMAX_PREFS_Rollout rolledUp state do
	(
		if state then 
			(			
				BMAX_Rollout.height = 830
			)
			else
				(
					BMAX_Rollout.height = 140
				)
	)
	 
	on spn_e_globalScale changed val do 
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "GlobalScale" ((spn_e_globalScale.value) as string)							
	)	
	on dd_e_convertUnits selected val do
	(	
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "ConvertUnits" ((dd_e_convertUnits.selection) as string)
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "ConvertUnits_sys" ((dd_e_convertUnits.items[val]) as string)
	)
	on dd_e_upAxis selected val do
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "UpAxis" ((dd_e_upAxis.selection) as string)
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "UpAxis_sys" ((dd_e_upAxis.items[val]) as string)
	)
	on dd_e_fbx_ver selected val do
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "FBX_Version" ((dd_e_fbx_ver.selection) as string)
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "FBX_Version_sys" ((dd_e_fbx_ver.items[val]) as string)
	)
	on ckb_e_preserveInstances changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Preserveinstances" ((ckb_e_preserveInstances.state) as string)							
 	)
	on ckb_e_smoothingGroups changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "SmoothingGroups" ((ckb_e_smoothingGroups.state) as string)							
 	)
	on ckb_e_cameras changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Cameras" ((ckb_e_cameras.state) as string)							
 	)
	on ckb_e_lights changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Lights" ((ckb_e_lights.state) as string)							
 	)
	on ckb_e_animation changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "Animation" ((ckb_e_animation.state) as string)							
 	)
	on ckb_e_collapseStack changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "collapseStack" ((ckb_e_collapseStack.state) as string)							
 	)
	on ckb_e_resetXform changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "ResetXform" ((ckb_e_resetXform.state) as string)							
 	)
	on ckb_e_convertToPoly changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Export" "convertToPoly" ((ckb_e_convertToPoly.state) as string)							
 	)
	
	
	
	on spn_i_globalScale changed val do 
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "GlobalScale" ((spn_i_globalScale.value) as string)							
	)	
	on dd_i_convertUnits selected val do
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ConvertUnits" ((dd_i_convertUnits.selection) as string)
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ConvertUnits_sys" ((dd_i_convertUnits.items[val]) as string)
	)
	on dd_i_upAxis selected val do
	(
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "UpAxis" ((dd_i_upAxis.selection) as string)
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "UpAxis_sys" ((dd_i_upAxis.items[val]) as string)
	)
	
	on ckb_i_wireColorRandom changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireRandomColor" ((ckb_i_wireColorRandom.state) as string)		
		if state then
			(	
				setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireColorEnabled" "false"
				colorpicker_i_wireColor.enabled = false
			)
			else
				(
					setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireColorEnabled" "true"
					colorpicker_i_wireColor.enabled = true
				)
 	)	
	
	on colorpicker_i_wireColor changed val do
	(		
		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "WireColor" (([colorpicker_i_wireColor.color.red,colorpicker_i_wireColor.color.green,colorpicker_i_wireColor.color.blue]) as string)
	)
	
	
	
	on ckb_i_smoothingGroups changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "SmoothingGroups" ((ckb_i_smoothingGroups.state) as string)							
 	)
	on ckb_i_cameras changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Cameras" ((ckb_i_cameras.state) as string)							
 	)
	on ckb_i_lights changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Lights" ((ckb_i_lights.state) as string)							
 	)	
	on ckb_i_animation changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Animation" ((ckb_i_animation.state) as string)							
 	)
	on ckb_i_ResetXForm changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ResetXForm" ((ckb_i_ResetXForm.state) as string)							
 	)	
	on ckb_i_BakeAnimationLayers changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "BakeAnimationLayers" ((ckb_i_BakeAnimationLayers.state) as string)							
 	)	
	on ckb_i_FillTimeline changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FillTimeline" ((ckb_i_FillTimeline.state) as string)							
 	)	
	on ckb_i_FilterKeyReducer changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FilterKeyReducer" ((ckb_i_FilterKeyReducer.state) as string)							
 	)	
	on ckb_i_FilterKeySync changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "FilterKeySync" ((ckb_i_FilterKeySync.state) as string)							
 	)	
	on ckb_i_KeepFrameRate changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "KeepFrameRate" ((ckb_i_KeepFrameRate.state) as string)							
 	)	
	on ckb_i_ImportBoneAsDummy changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "ImportBoneAsDummy" ((ckb_i_ImportBoneAsDummy.state) as string)							
 	)	
	on ckb_i_Markers changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Markers" ((ckb_i_Markers.state) as string)							
 	)	
	on ckb_i_PointCache changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "PointCache" ((ckb_i_PointCache.state) as string)							
 	)	
	on ckb_i_Shape changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Shape" ((ckb_i_Shape.state) as string)							
 	)	
	on ckb_i_Skin changed state do 
 	(
 		setINISetting ("$userscripts\\BMAX\\bmax.ini") "Import" "Skin" ((ckb_i_Skin.state) as string)							
 	)	
)

createDialog BMAX_Rollout 160 140 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
addSubRollout BMAX_Rollout.prefs_frame BMAX_PREFS_Rollout

