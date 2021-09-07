import bpy
import os
import os.path
import tempfile
from .misc import (BMAX_Add_Custom_prop, BMAX_Delete_Custom_prop)

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
