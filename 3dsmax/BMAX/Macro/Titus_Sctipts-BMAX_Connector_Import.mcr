macroScript BMAX_Connector_Import
	category:"Titus_Scripts"
	buttonText:"BMAX Import"
	toolTip:"BMAX Import"
	Icon:#("bmax" ,1)

(
	include "$userscripts\\BMAX\\Bmax_Functions.ms"
    BMAX_Import ((getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Path" "BMAX") + ("\BMAX_TMP_BLENDER.fbx"))	
)