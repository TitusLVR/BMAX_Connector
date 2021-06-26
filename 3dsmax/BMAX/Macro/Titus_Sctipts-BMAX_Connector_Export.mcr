macroScript BMAX_Connector_Export
	category:"Titus_Scripts"
	buttonText:"BMAX Export"
	toolTip:"BMAX Export"
	Icon:#("bmax" ,1)

(
	include "$userscripts\\BMAX\\Bmax_Functions.ms"
	BMAX_Export ((getINISetting  ("$userscripts\\BMAX\\bmax.ini") "Path" "BMAX") + ("\BMAX_TMP_MAX.fbx"))	
)