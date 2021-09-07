import bpy
import os
import os.path
import tempfile
from .misc import (BMAX_Add_Custom_prop, BMAX_Delete_Custom_prop)



def BMAX_Export_USD():
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
    
    temp_file_blender = path + "/BMAX_TMP_BLENDER.usd"       
              
    #---EXPORT---
    if prefs.export_reset_location or prefs.export_reset_rotation or prefs.export_reset_scale:
        BMAX_Add_Custom_prop()


    # global_scale = bpy.context.preferences.addons['BMAX_Connector'].preferences.global_scale_export
    bpy.ops.wm.usd_export(filepath=temp_file_blender,
                            check_existing=True,
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
                            display_type='DEFAULT',
                            sort_method='FILE_SORT_ALPHA',
                            selected_objects_only=True,
                            export_animation=False,
                            export_hair=False,
                            export_uvmaps=True,
                            export_normals=True,
                            export_materials=True,
                            use_instancing=True,
                            evaluation_mode='VIEWPORT'
                            )
    
    if prefs.export_reset_location or prefs.export_reset_rotation or prefs.export_reset_scale:
        BMAX_Delete_Custom_prop()