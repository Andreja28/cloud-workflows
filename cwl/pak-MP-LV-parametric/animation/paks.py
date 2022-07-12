# trace generated using paraview version 5.10.0-RC1

#### import the simple module from the paraview
from paraview.simple import *
import os
os.mkdir("_results")
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# create a new 'Legacy VTK Reader'
pAKS000 = LegacyVTKReader(registrationName='PAKS000*',FileNames=sys.argv[1:])
# get animation scene
animationScene1 = GetAnimationScene()

# update animation scene based on data timesteps
animationScene1.UpdateAnimationUsingDataTimeSteps()

# set active source
SetActiveSource(pAKS000)

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
pAKS000Display = Show(pAKS000, renderView1, 'UnstructuredGridRepresentation')

# trace defaults for the display properties.
pAKS000Display.Representation = 'Surface'
pAKS000Display.ColorArrayName = [None, '']
pAKS000Display.OSPRayScaleArray = 'displacement'
pAKS000Display.OSPRayScaleFunction = 'PiecewiseFunction'
pAKS000Display.SelectOrientationVectors = 'displacement'
pAKS000Display.ScaleFactor = 7.2340534210205085
pAKS000Display.SelectScaleArray = 'None'
pAKS000Display.GlyphType = 'Arrow'
pAKS000Display.GlyphTableIndexArray = 'None'
pAKS000Display.GaussianRadius = 0.3617026710510254
pAKS000Display.SetScaleArray = ['POINTS', 'displacement']
pAKS000Display.ScaleTransferFunction = 'PiecewiseFunction'
pAKS000Display.OpacityArray = ['POINTS', 'displacement']
pAKS000Display.OpacityTransferFunction = 'PiecewiseFunction'
pAKS000Display.DataAxesGrid = 'GridAxesRepresentation'
pAKS000Display.PolarAxes = 'PolarAxesRepresentation'
pAKS000Display.ScalarOpacityUnitDistance = 17.344594273175826

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
pAKS000Display.ScaleTransferFunction.Points = [-0.49080872535705566, 0.0, 0.5, 0.0, 0.0011794200399890542, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
pAKS000Display.OpacityTransferFunction.Points = [-0.49080872535705566, 0.0, 0.5, 0.0, 0.0011794200399890542, 1.0, 0.5, 0.0]

# get the material library
materialLibrary1 = GetMaterialLibrary()

# reset view to fit data
renderView1.ResetCamera()

# set scalar coloring
ColorBy(pAKS000Display, ('POINTS', 'displacement', 'Magnitude'))

# rescale color and/or opacity maps used to include current data range
pAKS000Display.RescaleTransferFunctionToDataRange(True, False)

# show color bar/color legend
pAKS000Display.SetScalarBarVisibility(renderView1, True)

# get color transfer function/color map for 'displacement'
displacementLUT = GetColorTransferFunction('displacement')
displacementLUT.RGBPoints = [0.0, 0.231373, 0.298039, 0.752941, 0.24638636469708194, 0.865003, 0.865003, 0.865003, 0.4927727293941639, 0.705882, 0.0156863, 0.14902]
displacementLUT.ScalarRangeInitialized = 1.0

# get opacity transfer function/opacity map for 'displacement'
displacementPWF = GetOpacityTransferFunction('displacement')
displacementPWF.Points = [0.0, 0.0, 0.5, 0.0, 0.4927727293941639, 1.0, 0.5, 0.0]
displacementPWF.ScalarRangeInitialized = 1

# get layout
layout1 = GetLayout()

# layout/tab size in pixels
displasmentLUTColorBar = GetScalarBar(displacementLUT, renderView1)

displasmentLUTColorBar.WindowLocation = 'AnyLocation'

displasmentLUTColorBar.Position = [0.7331711273317113, 0.2951388888888889]
displasmentLUTColorBar.ScalarBarLength = 0.33
displasmentLUTColorBar.LabelFontSize = 5
displasmentLUTColorBar.TitleFontSize = 5

displacementLUT.ApplyPreset('Rainbow Desaturated', True)

# current camera placement for renderView1
renderView1.CameraPosition = [33.73704189160999, -12.621845542023095, -179.6596449378643]
renderView1.CameraFocalPoint = [-19.95627307891844, 0.015108108520503252, 18.087141036987312]
renderView1.CameraViewUp = [0.1507012171563254, 0.9883291660791559, -0.022239663326641422]
renderView1.CameraParallelScale = 53.13451998937037

# save animation
SaveAnimation(os.path.join('_results','displasments-solid.ogv'), renderView1, ImageResolution=[1920, 1080],
    FrameWindow=[0, 10])

# # set scalar coloring
# ColorBy(pAKS000Display, ('POINTS', 'velocities', 'Magnitude'))

# # Hide the scalar bar for this color map if no visible data is colored by it.
# HideScalarBarIfNotNeeded(displacementLUT, renderView1)

# # rescale color and/or opacity maps used to include current data range
# pAKS000Display.RescaleTransferFunctionToDataRange(True, False)

# # show color bar/color legend
# pAKS000Display.SetScalarBarVisibility(renderView1, True)

# # get color transfer function/color map for 'velocities'
# velocitiesLUT = GetColorTransferFunction('velocities')
# velocitiesLUT.RGBPoints = [0.0, 0.231373, 0.298039, 0.752941, 2.4638636479676266, 0.865003, 0.865003, 0.865003, 4.927727295935253, 0.705882, 0.0156863, 0.14902]
# velocitiesLUT.ScalarRangeInitialized = 1.0

# # get opacity transfer function/opacity map for 'velocities'
# velocitiesPWF = GetOpacityTransferFunction('velocities')
# velocitiesPWF.Points = [0.0, 0.0, 0.5, 0.0, 4.927727295935253, 1.0, 0.5, 0.0]
# velocitiesPWF.ScalarRangeInitialized = 1

# velocitiesLUTColorBar = GetScalarBar(velocitiesLUT, renderView1)

# velocitiesLUTColorBar.WindowLocation = 'AnyLocation'

# velocitiesLUTColorBar.Position = [0.7331711273317113, 0.2951388888888889]
# velocitiesLUTColorBar.ScalarBarLength = 0.33
# velocitiesLUTColorBar.LabelFontSize = 5
# velocitiesLUTColorBar.TitleFontSize = 5

# velocitiesLUT.ApplyPreset('Rainbow Desaturated', True)
# # layout/tab size in pixels

# # current camera placement for renderView1
# renderView1.CameraPosition = [33.73704189160999, -12.621845542023095, -179.6596449378643]
# renderView1.CameraFocalPoint = [-19.95627307891844, 0.015108108520503252, 18.087141036987312]
# renderView1.CameraViewUp = [0.1507012171563254, 0.9883291660791559, -0.022239663326641422]
# renderView1.CameraParallelScale = 53.13451998937037

# # save animation
# SaveAnimation(os.path.join('_results','velocities-solid.ogv'), renderView1, ImageResolution=[1920, 1080],
#     FrameWindow=[0, 10])