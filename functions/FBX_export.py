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

	bpy.ops.export_scene.fbx(filepath = temp_file_blender,
										check_existing=True,
										filter_glob="*.fbx",
										use_selection=True,
										use_active_collection=False,
										global_scale=prefs.global_scale_export,
										apply_unit_scale=prefs.fbx_export_apply_unit_scale,
										apply_scale_options=prefs.fbx_export_apply_scale_options,
										use_space_transform =prefs.fbx_export_use_space_transform,
										bake_space_transform=prefs.fbx_export_bake_space_transform,
										object_types={'EMPTY', 'CAMERA', 'LIGHT', 'ARMATURE', 'MESH', 'OTHER'},
										use_mesh_modifiers=prefs.fbx_export_use_mesh_modifiers,
										use_mesh_modifiers_render=prefs.fbx_export_use_mesh_modifiers_render,
										mesh_smooth_type=prefs.fbx_export_mesh_smooth_type,
										use_mesh_edges=prefs.fbx_export_use_mesh_edges,
										use_tspace=prefs.fbx_export_use_tspace,
										use_custom_props=prefs.fbx_export_use_custom_props,
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
										use_metadata=True,
										axis_forward=prefs.fbx_export_axis_forward,
										axis_up=prefs.fbx_export_axis_up,
										)

	if prefs.export_reset_location or prefs.export_reset_rotation or prefs.export_reset_scale:
		BMAX_Delete_Custom_prop()
