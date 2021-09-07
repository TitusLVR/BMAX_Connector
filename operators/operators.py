import bpy
from bpy.types import Operator
from ..functions.FBX_export import BMAX_Export
from ..functions.FBX_import import BMAX_Import
from ..functions.USD_export import BMAX_Export_USD
from ..functions.USD_import import BMAX_Import_USD


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

class BMAX_OT_Export_USD(Operator):
    bl_idname = "bmax.export_usd"
    bl_label = "Send to Maya/3dsmax"
    bl_description = "Export USD to Maya/3dsmax"
    bl_options = {'REGISTER', 'UNDO'} 
    
    def execute(self, context):        
        if len(bpy.context.selected_objects) == 0:
            self.report ({'INFO'}, 'Selection is empty! Please select some objects!!') 
            return {'FINISHED'}
        else:
            BMAX_Export_USD()
            self.report ({'INFO'}, 'BMAX - EXPORT DONE!')
            return {'FINISHED'}

class BMAX_OT_Import_USD(Operator):
    bl_idname = "bmax.import_usd"
    bl_label = "Import from Maya/3dsmax"
    bl_description = "Import USD from Maya/3dsmax"
    bl_options = {'REGISTER', 'UNDO'} 
    
    def execute(self, context):        
        BMAX_Import_USD()
        self.report ({'INFO'}, 'BMAX - IMPORT DONE!')
        return {'FINISHED'}