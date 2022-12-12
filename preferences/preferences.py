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
from ..ui.panel import (VIEW3D_PT_BMAX)

# Panels to update
panels = (VIEW3D_PT_BMAX,)

def update_category(self, context):
    message = "Panel Update Failed"
    try:
        for panel in panels:
            if "bl_rna" in panel.__dict__:
                bpy.utils.unregister_class(panel)

        for panel in panels:
            panel.bl_category = context.preferences.addons["BMAX_Connector"].preferences.category
            bpy.utils.register_class(panel)

    except Exception as e:
        print("\n[{}]\n{}\n\nError:\n{}".format("BMAX_Connector", message, e))
        pass


class BMAX_AddonPreferences(AddonPreferences):
	bl_idname = "BMAX_Connector"

	category: StringProperty(
        name="Tab Name",
        description="Choose a name for the category of the panel",
        default="BMAX",
        update=update_category
        )

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

	fbx_export_apply_unit_scale: BoolProperty(
		name="Apply Unit",
		description='Apply Unit, Take into account current Blender units settings (if unset, raw Blender Units values are used as-is)',
		default=True,
	)

	fbx_export_use_space_transform: BoolProperty(
		name="Use Space Transform",
		description='Apply global space transform to the object rotations. When disabled only the axis space is written to the file and all object transforms are left as-is',
		default=True,
	)

	fbx_export_bake_space_transform: BoolProperty(
		name="Apply Transform",
		description='Bake space transform into object data, avoids getting unwanted rotations to objects when target space is not aligned with Blender space (WARNING! experimental option, use at own risks, known broken with armatures/animations)',
		default=False,
	)

	fbx_export_use_subsurf: BoolProperty(
		name="Export Subdivision Surface",
		description='Export the last Catmull-Rom subdivision modifier as FBX subdivision (does not apply the modifier even if `Apply Modifiers` is enabled)',
		default=False,
	)

	fbx_export_use_mesh_edges: BoolProperty(
		name="Loose Edges",
		description='Export loose edges (as two-vertices polygons)',
		default=False,
	)

	fbx_export_use_tspace: BoolProperty(
		name="Tangent Space",
		description='Add binormal and tangent vectors, together with normal they form the tangent space (will only work correctly with tris/quads only meshes!)',
		default=False,
	)

	fbx_export_use_triangles: BoolProperty(
		name="Triangulate Faces",
		description='Convert all faces to triangles',
		default=False,
	)

	fbx_export_use_custom_props: BoolProperty(
		name="Custom Properties",
		description='Export custom properties',
		default=False,
	)

	fbx_export_use_mesh_modifiers: BoolProperty(
		name="Apply Modifiers",
		description='Apply modifiers to mesh objects (except Armature ones) - WARNING: prevents exporting shape keys',
		default=True,
	)

	fbx_export_use_mesh_modifiers_render: BoolProperty(
		name="Use Modifiers Render Setting",
		description='Use render settings when applying modifiers to mesh objects (DISABLED in Blender 2.8)',
		default=False,
	)

	fbx_export_apply_scale_options: EnumProperty(
		name="Apply Scale",
		description='Apply Scalings, How to apply custom and units scalings in generated FBX file\n(Blender uses FBX scale to detect units on import, but many other applications do not handle the same way)',
		items=[('FBX_SCALE_NONE', 'All Local',  'Apply custom scaling and units scaling to each object transformation, FBX scale remains at 1.0', '', 0),
			   ('FBX_SCALE_UNITS', 'Units Scale',  'Apply custom scaling to each object transformation, and units scaling to FBX scale', '', 1),
			   ('FBX_SCALE_CUSTOM', 'Custom Scale',  'Apply custom scaling to FBX scale, and units scaling to each object transformation', '', 2),
			   ('FBX_SCALE_ALL', 'All',	 'Apply custom scaling and units scaling to FBX scale', '', 3),
			  ],
		default='FBX_SCALE_NONE',
	)

	fbx_export_axis_forward: EnumProperty(
		name='Forward axis',
		description='Forward',
		items=[('X', 'X',  '', '', 0),
			   ('Y', 'Y',  '', '', 1),
			   ('Z', 'Z',  '', '', 2),
			   ('-X', '-X',	 '', '', 3),
			   ('-Y', '-Y',	 '', '', 4),
			   ('-Z', '-Z',	 '', '', 5),
			  ],
		default='-Y',
	)

	fbx_export_axis_up: EnumProperty(
		name='Up Axis',
		description='Up',
		items=[('X', 'X',  '', '', 0),
			   ('Y', 'Y',  '', '', 1),
			   ('Z', 'Z',  '', '', 2),
			   ('-X', '-X',	 '', '', 3),
			   ('-Y', '-Y',	 '', '', 4),
			   ('-Z', '-Z',	 '', '', 5),
			  ],
		default='Z',
	)

	fbx_export_mesh_smooth_type: EnumProperty(
		name='Mesh Smooth Type',
		description="Smoothing, Export smoothing information (prefer 'Normals Only' option if your target importer understand split normals)",
		items=[('OFF', 'Normals Only',  'Export only normals instead of writing edge or face smoothing data(Normals Only)', '', 0),
				('FACE', 'Face',  'Write face smoothing', '', 1),
				('EDGE', 'Edge',  'Write edge smoothing', '', 2),
			  ],
		default='OFF',
	)


	def draw(self, context):
		layout = self.layout
		col = layout.column(align=True)
		# Category
		box = col.box()
		col = box.column(align=True)
		col.label(text="Category:")
		col.prop(self, "category")

		box = col.box()
		col = box.column(align=True)
		col.label(text="FBX export settings:")
		row=col.row(align=True)
		# OBJECT
		col = row.column(align=False)
		box = col.box()
		col = box.column(align=True)
		col.label(text="Object:")
		col.prop(self, "fbx_export_use_custom_props",toggle=True)
		# col.prop(self, "fbx_export_vc_colors_type")
		# TRANSFORM
		col = row.column(align=False)
		box = col.box()
		col = box.column(align=True)
		col.label(text="Transform:")
		col.prop(self, "global_scale_export")
		col.prop(self, "fbx_export_use_space_transform",toggle=True)
		col.prop(self, "fbx_export_apply_scale_options")
		col.prop(self, "fbx_export_axis_forward")
		col.prop(self, "fbx_export_axis_up")
		col.prop(self, "fbx_export_apply_unit_scale",toggle=True)
		col.prop(self, "fbx_export_bake_space_transform",toggle=True)
		# GEOMETRY
		col = row.column(align=False)
		box = col.box()
		col = box.column(align=True)
		col.label(text="Geometry:")
		col.prop(self, "fbx_export_mesh_smooth_type")
		col.prop(self, "fbx_export_use_subsurf",toggle=True)
		col.prop(self, "fbx_export_use_mesh_modifiers",toggle=True)
		col.prop(self, "fbx_export_use_mesh_modifiers_render",toggle=True)
		col.prop(self, "fbx_export_use_mesh_edges",toggle=True)
		col.prop(self, "fbx_export_use_triangles",toggle=True)
		col.prop(self, "fbx_export_use_tspace",toggle=True)

		col = layout.column()
		box = col.box()
		col = box.column(align=True)
		col.label(text="FBX Import settings:")
		col.prop(self, "global_scale_import")

		col = layout.column()
		col.label(text = "Select custom BMAX exchange folder(keep it empty for default BMAX folder)")
		col.prop(self, "tempFolder")
		col.prop(self, "file_format")

