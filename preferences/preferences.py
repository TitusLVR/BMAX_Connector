import bpy
from bpy.types import AddonPreferences
from bpy.props import (
        BoolProperty,
        EnumProperty,
        FloatProperty,
        IntProperty,
        PointerProperty,
        StringProperty,
        )

class BMAX_AddonPreferences(AddonPreferences):
    bl_idname = "BMAX_Connector"    

    file_format: EnumProperty(
        name='File Format',
        description='FBX or USD',
        items=[
            ('FBX', 'FBX',  '', '', 0),
            ('USD', 'USD',  '', '', 1),
            ],
        default='FBX',
    )

    global_scale_export: FloatProperty(
        name="Global Scale Export ",
        description="FBX export global scale",
        default=1,
        min=0.000,
        max=1000000000.000,
        step=0.1,
        precision=3
    )
    global_scale_import: FloatProperty(
        name="Global Scale Import",
        description="FBX import global scale",
        default=1,
        min=0.000,
        max=1000000000.000,
        step=0.1,
        precision=3
    )
    
    display_global_scale: bpy.props.BoolProperty(name="Import/Export", description="BMAX Preferences", default=False)
    export_reset_location: bpy.props.BoolProperty(name="Reset Location", description="Reset object location on export, and restore after", default=False)
    export_reset_rotation: bpy.props.BoolProperty(name="Reset Rotation", description="Reset object rotation on export, and restore after", default=False)
    export_reset_scale: bpy.props.BoolProperty(name="Reset Scale", description="Reset object scale on export, and restore after", default=False)

    tempFolder : StringProperty(
        name = "BMAX custom exchange folder",
        subtype = 'DIR_PATH',
        )  

    def draw(self, context):
        layout = self.layout
        col = layout.column(align=True)        
        col.label(text = "FBX import/export global scale")
        col.prop(self, "global_scale_export") 
        col.prop(self, "global_scale_import")              
        col.label(text = "Select custom BMAX exchange folder(keep it empty for default BMAX folder)")
        col.prop(self, "tempFolder")
        col.prop(self, "file_format")
         
