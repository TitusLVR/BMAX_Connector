import bpy

def BMAX_Add_Custom_prop():
    prefs = bpy.context.preferences.addons['BMAX_Connector'].preferences
    for ob in bpy.context.view_layer.objects.selected:
        ob["BMAX"] = (ob.location, ob.rotation_euler, ob.scale)
        if prefs.export_reset_location:
            ob.location = (0,0,0)
        if prefs.export_reset_rotation:
            ob.rotation_euler = (0,0,0)
        if prefs.export_reset_scale:
            ob.scale = (1,1,1)

def BMAX_Delete_Custom_prop():
    prefs = bpy.context.preferences.addons['BMAX_Connector'].preferences
    for ob in bpy.context.view_layer.objects.selected:
        if "BMAX" in ob.keys():
            if prefs.export_reset_location:
                ob.location = ob["BMAX"][0]
            if prefs.export_reset_rotation:
                ob.rotation_euler = ob["BMAX"][1]
            if prefs.export_reset_scale:
                ob.scale = ob["BMAX"][2]
            del ob["BMAX"] 