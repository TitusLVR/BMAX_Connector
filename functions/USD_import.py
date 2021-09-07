import bpy
import os
import os.path
import tempfile

def BMAX_Import_USD():
    #---Variables---         
    customPath = bpy.context.preferences.addons['BMAX_Connector'].preferences.tempFolder
    if customPath == '':            
        path = "" + tempfile.gettempdir() + "\\BMAX"
        path = '/'.join(path.split('\\'))
        if not os.path.exists(path):
            os.makedirs(path)
    else:
        path = bpy.context.preferences.addons['BMAX_Connector'].preferences.tempFolder
    
    temp_file_max = path + "/BMAX_TMP_MAX.usd"
    #---IMPORT---        
    #---Import FBX---
    global_scale = bpy.context.preferences.addons['BMAX_Connector'].preferences.global_scale_import
    if os.path.isfile(temp_file_max) == True:
        bpy.ops.wm.usd_import(filepath=temp_file_max,
                                filter_blender=False,
                                filter_backup=False,
                                filter_image=False,
                                filter_movie=False,
                                filter_python=False,
                                filter_font=False,
                                filter_sound=False,
                                filter_text=False,
                                filter_archive=False,
                                filter_btx=False,
                                filter_collada=False,
                                filter_alembic=False,
                                filter_usd=True,
                                filter_volume=False,
                                filter_folder=True,
                                filter_blenlib=False,
                                filemode=8,
                                relative_path=True,
                                display_type='DEFAULT',
                                sort_method='FILE_SORT_ALPHA',
                                scale=global_scale,
                                set_frame_range=True,
                                import_cameras=True,
                                import_curves=True,
                                import_lights=True,
                                import_materials=True,
                                import_meshes=True,
                                import_volumes=True,
                                import_subdiv=False,
                                import_instance_proxies=True,
                                import_visible_only=False,
                                create_collection=False,
                                read_mesh_uvs=True,
                                read_mesh_colors=True,
                                prim_path_mask="",
                                import_guide=False,
                                import_proxy=True,
                                import_render=True,
                                import_usd_preview=True,
                                set_material_blend=True,
                                light_intensity_scale=1
                                ) 
        if len(bpy.context.selected_objects) != 0:
            bpy.context.view_layer.objects.active = bpy.context.selected_objects[0] 
    