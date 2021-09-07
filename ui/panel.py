import bpy
from bpy.types import Panel

# panel containing all tools
class VIEW3D_PT_BMAX(Panel):
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = 'BMAX'    
    bl_label = "BMAX Conector"
    
    def draw(self, context):
        prefs = bpy.context.preferences.addons['BMAX_Connector'].preferences

        layout = self.layout
        col = layout.column(align=True)  
        col.scale_y = 1.5
        if prefs.file_format == 'FBX':     
            col.operator('bmax.export', icon='EXPORT',text = "Send to Maya/3dsmax")
            col.operator('bmax.import',icon='IMPORT', text="Get from Maya/3dsmax")
        if prefs.file_format == 'USD':
            col.operator('bmax.export_usd', icon='EXPORT',text = "Send to Maya/3dsmax")
            col.operator('bmax.import_usd',icon='IMPORT', text="Get from Maya/3dsmax")

        col = layout.column(align=True)
        box = col.box().column(align=True)
        if prefs.display_global_scale:
            row = box.row(align=True)
            row.prop(prefs, "display_global_scale", text="", icon='TRIA_DOWN')
        else:
            row = box.row(align=True)
            row.prop(prefs, "display_global_scale", text="", icon='TRIA_RIGHT')
        row.label(text="Preferences")
        
        if prefs.display_global_scale:
            box.separator()
# Export preferences box
            box1 = col.box().column(align=True)
            col1 = box1.column(align=True)            
            col1.label(text="Export:") 
# Nested export preferences box
            box1_1 = col1.box().column(align=True)
            col1_1 = box1_1.column(align=True)
            
            col1_1.prop(prefs,"export_reset_location")
            col1_1.prop(prefs,"export_reset_rotation")
            col1_1.prop(prefs,"export_reset_scale")

            col1_1.prop(prefs,"global_scale_export")

# Import preferences box
            box2 = col.box().column(align=True)
            col2 = box2.column(align=True)
            col2.label(text="Import:")
# Nested import preferences box
            box2_1 = col2.box().column(align=True)
            col2_1 = box2_1.column(align=True)
             
            col2_1.prop(prefs,"global_scale_import")
            