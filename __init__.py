bl_info = {
    "name": "BMAX Connector",
    "author": "Titus Lavrov / Email: Titus.mailbox@gmail.com",
    "version": (0, 1, 3),
    "blender": (2, 80, 0),
    "location": "View3D > Toolbar and View3D",
    "warning": "",
    "description": "Bridge between 3dmax and Blender",
    "wiki_url": ""
                "",
    "category": "Import-Export",
}

import bpy
import os
import os.path
import tempfile
from bpy.types import (
        Operator,
        Menu,
        Panel,
        PropertyGroup,
        AddonPreferences,
        )
from bpy.props import (
        BoolProperty,
        EnumProperty,
        FloatProperty,
        IntProperty,
        PointerProperty,
        StringProperty,
        )
#Functions

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


def BMAX_Export(): 
    #---Variables---
    prefs = bpy.context.preferences.addons['BMAX_Connector'].preferences     
    customPath = prefs.tempFolder
    if customPath == '':            
        path = "" + tempfile.gettempdir() + "\\BMAX"
        path = '/'.join(path.split('\\'))
        if not os.path.exists(path):
            os.makedirs(path)
    else:
        path = prefs.tempFolder
    
    temp_file_blender = path + "/BMAX_TMP_BLENDER.fbx"       
              
    #---EXPORT---
    if prefs.export_reset_location or prefs.export_reset_rotation or prefs.export_reset_scale:
        BMAX_Add_Custom_prop()


    global_scale = bpy.context.preferences.addons['BMAX_Connector'].preferences.global_scale_export
    bpy.ops.export_scene.fbx(filepath = temp_file_blender,
                                 check_existing=True,
                                 filter_glob="*.fbx",                                  
                                 use_selection=True, 
                                 use_active_collection=False, 
                                 global_scale=global_scale, 
                                 apply_unit_scale=True, 
                                 apply_scale_options='FBX_SCALE_ALL', 
                                 bake_space_transform=True, 
                                 object_types= {'EMPTY', 'CAMERA', 'LIGHT', 'ARMATURE', 'MESH', 'OTHER'}, 
                                 use_mesh_modifiers=True, 
                                 use_mesh_modifiers_render=True, 
                                 mesh_smooth_type='OFF', 
                                 use_mesh_edges=False, 
                                 use_tspace=False, 
                                 use_custom_props=True, 
                                 add_leaf_bones=False, 
                                 primary_bone_axis='Y', 
                                 secondary_bone_axis='X', 
                                 use_armature_deform_only=False, 
                                 armature_nodetype='NULL', 
                                 bake_anim=False, 
                                 bake_anim_use_all_bones=False, 
                                 bake_anim_use_nla_strips=False, 
                                 bake_anim_use_all_actions=False, 
                                 bake_anim_force_startend_keying=False, 
                                 bake_anim_step=1, 
                                 bake_anim_simplify_factor=1, 
                                 path_mode='AUTO', 
                                 embed_textures=False, 
                                 batch_mode='OFF', 
                                 use_batch_own_dir=True, 
                                 use_metadata=False, 
                                 axis_forward='Y', 
                                 axis_up='Z'
                                )
    
    if prefs.export_reset_location or prefs.export_reset_rotation or prefs.export_reset_scale:
        BMAX_Delete_Custom_prop()

def BMAX_Import():    
    #---Variables---         
    customPath = bpy.context.preferences.addons['BMAX_Connector'].preferences.tempFolder
    if customPath == '':            
        path = "" + tempfile.gettempdir() + "\\BMAX"
        path = '/'.join(path.split('\\'))
        if not os.path.exists(path):
            os.makedirs(path)
    else:
        path = bpy.context.preferences.addons['BMAX_Connector'].preferences.tempFolder
    
    temp_file_max = path + "/BMAX_TMP_MAX.fbx"
    #---IMPORT---        
    #---Import FBX---
    global_scale = bpy.context.preferences.addons['BMAX_Connector'].preferences.global_scale_import
    if os.path.isfile(temp_file_max) == True: 
        bpy.ops.import_scene.fbx(filepath=temp_file_max, 
                                         directory="", 
                                         filter_glob="*.fbx",
                                         use_manual_orientation=False, 
                                         global_scale=global_scale, 
                                         bake_space_transform=False, 
                                         use_custom_normals=True, 
                                         use_image_search=False, 
                                         use_alpha_decals=False, 
                                         decal_offset=0, 
                                         use_anim=False, 
                                         anim_offset=1, 
                                         use_custom_props=False, 
                                         use_custom_props_enum_as_string=False, 
                                         ignore_leaf_bones=False, 
                                         force_connect_children=False, 
                                         automatic_bone_orientation=False, 
                                         primary_bone_axis='Y', 
                                         secondary_bone_axis='X', 
                                         use_prepost_rot=True, 
                                         axis_forward='-Z', 
                                         axis_up='Y'
                                         )
        if len(bpy.context.selected_objects) != 0:
            bpy.context.view_layer.objects.active = bpy.context.selected_objects[0] 

class BMAX_OT_Export(Operator):
    bl_idname = "bmax.export"
    bl_label = "Send to Maya/3dsmax"
    bl_description = "Export FBX to Maya/3dsmax"
    bl_options = {'REGISTER', 'UNDO'} 
    
    def execute(self, context):        
        if len(bpy.context.selected_objects) == 0:
            self.report ({'INFO'}, 'Selection is empty! Please select some objects!!') 
            return {'FINISHED'}
        else:
            BMAX_Export()
            self.report ({'INFO'}, 'BMAX - EXPORT DONE!')
            return {'FINISHED'}

class BMAX_OT_Import(Operator):
    bl_idname = "bmax.import"
    bl_label = "Import from Maya/3dsmax"
    bl_description = "Import FBX from Maya/3dsmax"
    bl_options = {'REGISTER', 'UNDO'} 
    
    def execute(self, context):        
        BMAX_Import()
        self.report ({'INFO'}, 'BMAX - IMPORT DONE!')
        return {'FINISHED'}
        
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
        col.operator('bmax.export', icon='EXPORT',text = "Send to Maya/3dsmax")
        col.operator('bmax.import',icon='IMPORT', text="Get from Maya/3dsmax") 
        
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
            

class BMAX_AddonPreferences(AddonPreferences):
    bl_idname = __name__    

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
        props = bpy.context.preferences.addons[__name__].preferences    
        
        layout = self.layout
        col = layout.column(align=True)
        col.label(text = "FBX import/export global scale")
        col.prop(self, "global_scale_export") 
        col.prop(self, "global_scale_import")              
        col.label(text = "Select custom BMAX exchange folder(keep it empty for default BMAX folder)")
        col.prop(self, "tempFolder") 

 
#Classes for register and unregister
classes = (
            BMAX_OT_Export,
            BMAX_OT_Import,
            VIEW3D_PT_BMAX,             
            BMAX_AddonPreferences         
        )
    
def register():
    for cls in classes:
        bpy.utils.register_class(cls)
    print ("BMAX Connector - Registred!")

def unregister(): 
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)
    print ("BMAX Connector - UnRegistred!")

if __name__ == "__main__":
    register()