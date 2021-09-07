import bpy
import os
import os.path
import tempfile

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
                                         use_custom_props=True, 
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