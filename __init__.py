bl_info = {
    "name": "BMAX Connector",
    "author": "Titus Lavrov / Email: Titus.mailbox@gmail.com",
    "version": (0, 1, 6),
    "blender": (2, 80, 0),
    "location": "View3D > Toolbar and View3D",
    "warning": "",
    "description": "Bridge between 3dmax and Blender",
    "wiki_url": ""
                "",
    "category": "Import-Export",
}

import bpy

from .operators.operators import (BMAX_OT_Export, 
                                  BMAX_OT_Import,
                                  BMAX_OT_Export_USD,
                                  BMAX_OT_Import_USD)

from .ui.panel import VIEW3D_PT_BMAX
from .preferences.preferences import BMAX_AddonPreferences

#Classes for register and unregister
classes = (
            BMAX_OT_Export,
            BMAX_OT_Import,
            BMAX_OT_Export_USD,
            BMAX_OT_Import_USD,
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