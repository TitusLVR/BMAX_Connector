<<<<<<< HEAD
fn fn_find_MacroScript UI_CONFIG_FILE _MacroScript=
(
	if (maxversion())[1] < 17000 then
	--Bellow 3dsMax 2013
	(
		--Let us get all the available toolbars
		local theArray = (dotnetClass "System.IO.File").ReadAllLines UI_CONFIG_FILE
		local theToolbars = #()
		for n in theArray do
		(
			if matchpattern n pattern:"[*]" do 
			(
				ss = subString n 2 (n.count - 2)
				ItemCount = getINIsetting UI_CONFIG_FILE ss "ItemCount"
				if ItemCount != "" do 
				(
					append theToolbars ss
				)
			)
		)

		--Search in all the toolbars
		for t in theToolbars do
		(
			local item_list = #()
			local single_item = #()
			
			--Get ItemCount
			local current_itemcount = (getINISetting UI_CONFIG_FILE t "ItemCount") as integer

			--Check if the Icon is already there...
			for i = 0 to current_itemcount do
			(
				if matchpattern (getINISetting UI_CONFIG_FILE t ("Item"+(i as string))) pattern:("*|" + _MacroScript +"`*") == true do
				(
					--It seems to be there!
					return true
				)
			)
		)
		--Not found
		return false
	)
	else
	--3dsMax 2013 and above
	(
		--Load the xml assemply
		dotNet.loadAssembly "system.xml"
		--Create an xml document object.
		local xmlDoc=dotNetObject "system.xml.xmlDocument"
			
		--Load the XML file.
		xmlDoc.load UI_CONFIG_FILE
		--Check to make sure the xmlDoc has a root element. 
		local docEle = xmlDoc.documentElement
		local itemIter = (xmldoc.selectnodes "//ADSK_CUI/CUIWindows")
		local CUIWindows = itemIter.itemOf[0]
		local CUIWindowsChildNodes = CUIWindows.ChildNodes
		for i=0 to CUIWindowsChildNodes.count-1 do
		(
			if (CUIWindowsChildNodes.ItemOf[i]).name == "Window" do
			(
				local WindowChildNodes = (CUIWindowsChildNodes.ItemOf[i]).ChildNodes
				for j=0 to WindowChildNodes.count-1 do
				(
					if ((WindowChildNodes.ItemOf[j]).name) == "Items" do
					(
						local ItemsChildNodes = (WindowChildNodes.ItemOf[j]).ChildNodes
						for k=0 to ItemsChildNodes.count-1 do
						(
							local ItemAttributes = (ItemsChildNodes.ItemOf[k]).attributes
							for l=0 to ItemAttributes.count-1 do
							(
								if ItemAttributes.ItemOf[l].name == "actionID" do
								(
									if matchpattern ItemAttributes.ItemOf[l].value pattern:(_MacroScript + "`*") do
									(
										return true
									)
								)
							)
						)
					)
				)
			)
		)
		return false
	)
)

fn addIcon UI_CONFIG_FILE _MacroScript _Category _ToolTip _Label =
(
	if (maxversion())[1] < 15000 then
	--Bellow 3dsMax 2013
	(
		local current_itemcount = (getINISetting UI_CONFIG_FILE "Main Toolbar" "ItemCount") as integer
		
		--Gets the button size
		local button_sizes_array = filterString (getINISetting UI_CONFIG_FILE "Main Toolbar" "Drect" as string) " "
		local button_size = (button_sizes_array[button_sizes_array.count] as integer) - 60
		
		--New Drect and CurPos numbers
		--if the button has an icon it has to add "23" or "32", deppending on the size of the buttons.
		local set_drect = ((button_sizes_array[button_sizes_array.count - 1] as integer) + button_size) as string
		
		--Replace the Drect and CurPos numbers (both will have the same number)
		setINISetting UI_CONFIG_FILE "Main Toolbar" "Drect" (substituteString (getINISetting UI_CONFIG_FILE "Main Toolbar" "Drect" as string) (button_sizes_array[button_sizes_array.count - 1]) set_drect)
		setINISetting UI_CONFIG_FILE "Main Toolbar" "CurPos" (substituteString (getINISetting UI_CONFIG_FILE "Main Toolbar" "CurPos" as string) (button_sizes_array[button_sizes_array.count - 1]) set_drect)
		
		--Add 1 to ItemCount
		setINISetting UI_CONFIG_FILE "Main Toolbar" "ItemCount" ((current_itemcount + 1) as string)
		
		--Add new Item
		setINISetting UI_CONFIG_FILE "Main Toolbar" ("Item"+((current_itemcount) as string)) ("2|0|0|31|3|647394|" + _MacroScript + "`" + _Category + "|0|0|" + "\"" + _ToolTip + "\"" + "|" + "\"" + _Label + "\"" + "|-1|")
	)
	else
	--3dsMax 2013 and above
	(
		--Load the xml assemply
		dotNet.loadAssembly "system.xml"
		--Create an xml document object.
		local xmlDoc=dotNetObject "system.xml.xmlDocument"
			
		--Load the XML file.
		xmlDoc.load UI_CONFIG_FILE
		--Check to make sure the xmlDoc has a root element. 
		local docEle = xmlDoc.documentElement
		local itemIter = (xmldoc.selectnodes "//ADSK_CUI/CUIWindows")
		local CUIWindows = itemIter.itemOf[0]
		local CUIWindowsChildNodes = CUIWindows.ChildNodes
		for i=0 to CUIWindowsChildNodes.count-1 do
		(
			if (CUIWindowsChildNodes.ItemOf[i]).name == "Window" do
			(
				local WindowAttributes = (CUIWindowsChildNodes.ItemOf[i]).attributes
				for j=0 to WindowAttributes.count-1 do
				(
					if WindowAttributes.ItemOf[j].name == "name" AND WindowAttributes.ItemOf[j].value == "Main Toolbar" do
					(
						local WindowChildNodes = CUIWindowsChildNodes.ItemOf[i].ChildNodes
						for k=0 to WindowChildNodes.count-1 do
						(
							if (WindowChildNodes.ItemOf[k]).name == "Items" do
							(
								local theRoot = xmlDoc.createElement "Item" 
								theRoot.setAttribute "typeID" "2"
								theRoot.setAttribute "type" "CTB_MACROBUTTON"
								theRoot.setAttribute "width" "0"
								theRoot.setAttribute "height" "0"
								theRoot.setAttribute "controlID" "0"
								theRoot.setAttribute "macroTypeID" "3"
								theRoot.setAttribute "macroType" "MB_TYPE_ACTION"
								theRoot.setAttribute "actionTableID" "647394"
								theRoot.setAttribute "imageID" "-1"
								theRoot.setAttribute "imageName" ""
								theRoot.setAttribute "actionID" (_MacroScript + "`" + _Category)
								theRoot.setAttribute "tip" _toolTip
								theRoot.setAttribute "label" _label
								WindowChildNodes.ItemOf[k].appendChild theRoot
								xmlDoc.save UI_CONFIG_FILE
								return true
							)
						)
					)
				)
			)
		)
		return false
	)
)
filein "$usermacros\\Titus_Scripts-BMAX_Connector.mcr"

colorman.reInitIcons()
MaxStartUI = cui.getConfigFile()
deleteFile MaxStartUI
cui.saveConfigAs MaxStartUI
if (fn_find_MacroScript MaxStartUI "BMAX_Connector") == false do
(
	addIcon MaxStartUI "BMAX_Connector" "Titus_Scripts" "BMAX" "BMAX"
)
=======
fn fn_find_MacroScript UI_CONFIG_FILE _MacroScript=
(
	if (maxversion())[1] < 17000 then
	--Bellow 3dsMax 2013
	(
		--Let us get all the available toolbars
		local theArray = (dotnetClass "System.IO.File").ReadAllLines UI_CONFIG_FILE
		local theToolbars = #()
		for n in theArray do
		(
			if matchpattern n pattern:"[*]" do 
			(
				ss = subString n 2 (n.count - 2)
				ItemCount = getINIsetting UI_CONFIG_FILE ss "ItemCount"
				if ItemCount != "" do 
				(
					append theToolbars ss
				)
			)
		)

		--Search in all the toolbars
		for t in theToolbars do
		(
			local item_list = #()
			local single_item = #()
			
			--Get ItemCount
			local current_itemcount = (getINISetting UI_CONFIG_FILE t "ItemCount") as integer

			--Check if the Icon is already there...
			for i = 0 to current_itemcount do
			(
				if matchpattern (getINISetting UI_CONFIG_FILE t ("Item"+(i as string))) pattern:("*|" + _MacroScript +"`*") == true do
				(
					--It seems to be there!
					return true
				)
			)
		)
		--Not found
		return false
	)
	else
	--3dsMax 2013 and above
	(
		--Load the xml assemply
		dotNet.loadAssembly "system.xml"
		--Create an xml document object.
		local xmlDoc=dotNetObject "system.xml.xmlDocument"
			
		--Load the XML file.
		xmlDoc.load UI_CONFIG_FILE
		--Check to make sure the xmlDoc has a root element. 
		local docEle = xmlDoc.documentElement
		local itemIter = (xmldoc.selectnodes "//ADSK_CUI/CUIWindows")
		local CUIWindows = itemIter.itemOf[0]
		local CUIWindowsChildNodes = CUIWindows.ChildNodes
		for i=0 to CUIWindowsChildNodes.count-1 do
		(
			if (CUIWindowsChildNodes.ItemOf[i]).name == "Window" do
			(
				local WindowChildNodes = (CUIWindowsChildNodes.ItemOf[i]).ChildNodes
				for j=0 to WindowChildNodes.count-1 do
				(
					if ((WindowChildNodes.ItemOf[j]).name) == "Items" do
					(
						local ItemsChildNodes = (WindowChildNodes.ItemOf[j]).ChildNodes
						for k=0 to ItemsChildNodes.count-1 do
						(
							local ItemAttributes = (ItemsChildNodes.ItemOf[k]).attributes
							for l=0 to ItemAttributes.count-1 do
							(
								if ItemAttributes.ItemOf[l].name == "actionID" do
								(
									if matchpattern ItemAttributes.ItemOf[l].value pattern:(_MacroScript + "`*") do
									(
										return true
									)
								)
							)
						)
					)
				)
			)
		)
		return false
	)
)

fn addIcon UI_CONFIG_FILE _MacroScript _Category _ToolTip _Label =
(
	if (maxversion())[1] < 15000 then
	--Bellow 3dsMax 2013
	(
		local current_itemcount = (getINISetting UI_CONFIG_FILE "Main Toolbar" "ItemCount") as integer
		
		--Gets the button size
		local button_sizes_array = filterString (getINISetting UI_CONFIG_FILE "Main Toolbar" "Drect" as string) " "
		local button_size = (button_sizes_array[button_sizes_array.count] as integer) - 60
		
		--New Drect and CurPos numbers
		--if the button has an icon it has to add "23" or "32", deppending on the size of the buttons.
		local set_drect = ((button_sizes_array[button_sizes_array.count - 1] as integer) + button_size) as string
		
		--Replace the Drect and CurPos numbers (both will have the same number)
		setINISetting UI_CONFIG_FILE "Main Toolbar" "Drect" (substituteString (getINISetting UI_CONFIG_FILE "Main Toolbar" "Drect" as string) (button_sizes_array[button_sizes_array.count - 1]) set_drect)
		setINISetting UI_CONFIG_FILE "Main Toolbar" "CurPos" (substituteString (getINISetting UI_CONFIG_FILE "Main Toolbar" "CurPos" as string) (button_sizes_array[button_sizes_array.count - 1]) set_drect)
		
		--Add 1 to ItemCount
		setINISetting UI_CONFIG_FILE "Main Toolbar" "ItemCount" ((current_itemcount + 1) as string)
		
		--Add new Item
		setINISetting UI_CONFIG_FILE "Main Toolbar" ("Item"+((current_itemcount) as string)) ("2|0|0|31|3|647394|" + _MacroScript + "`" + _Category + "|0|0|" + "\"" + _ToolTip + "\"" + "|" + "\"" + _Label + "\"" + "|-1|")
	)
	else
	--3dsMax 2013 and above
	(
		--Load the xml assemply
		dotNet.loadAssembly "system.xml"
		--Create an xml document object.
		local xmlDoc=dotNetObject "system.xml.xmlDocument"
			
		--Load the XML file.
		xmlDoc.load UI_CONFIG_FILE
		--Check to make sure the xmlDoc has a root element. 
		local docEle = xmlDoc.documentElement
		local itemIter = (xmldoc.selectnodes "//ADSK_CUI/CUIWindows")
		local CUIWindows = itemIter.itemOf[0]
		local CUIWindowsChildNodes = CUIWindows.ChildNodes
		for i=0 to CUIWindowsChildNodes.count-1 do
		(
			if (CUIWindowsChildNodes.ItemOf[i]).name == "Window" do
			(
				local WindowAttributes = (CUIWindowsChildNodes.ItemOf[i]).attributes
				for j=0 to WindowAttributes.count-1 do
				(
					if WindowAttributes.ItemOf[j].name == "name" AND WindowAttributes.ItemOf[j].value == "Main Toolbar" do
					(
						local WindowChildNodes = CUIWindowsChildNodes.ItemOf[i].ChildNodes
						for k=0 to WindowChildNodes.count-1 do
						(
							if (WindowChildNodes.ItemOf[k]).name == "Items" do
							(
								local theRoot = xmlDoc.createElement "Item" 
								theRoot.setAttribute "typeID" "2"
								theRoot.setAttribute "type" "CTB_MACROBUTTON"
								theRoot.setAttribute "width" "0"
								theRoot.setAttribute "height" "0"
								theRoot.setAttribute "controlID" "0"
								theRoot.setAttribute "macroTypeID" "3"
								theRoot.setAttribute "macroType" "MB_TYPE_ACTION"
								theRoot.setAttribute "actionTableID" "647394"
								theRoot.setAttribute "imageID" "-1"
								theRoot.setAttribute "imageName" ""
								theRoot.setAttribute "actionID" (_MacroScript + "`" + _Category)
								theRoot.setAttribute "tip" _toolTip
								theRoot.setAttribute "label" _label
								WindowChildNodes.ItemOf[k].appendChild theRoot
								xmlDoc.save UI_CONFIG_FILE
								return true
							)
						)
					)
				)
			)
		)
		return false
	)
)
filein "$usermacros\\Titus_Scripts-BMAX_Connector.mcr"

colorman.reInitIcons()
MaxStartUI = cui.getConfigFile()
deleteFile MaxStartUI
cui.saveConfigAs MaxStartUI
if (fn_find_MacroScript MaxStartUI "BMAX_Connector") == false do
(
	addIcon MaxStartUI "BMAX_Connector" "Titus_Scripts" "BMAX" "BMAX"
)
>>>>>>> 556b7fca844de37624045afeaadb4a7b4e4e9e34
cui.loadConfig MaxStartUI