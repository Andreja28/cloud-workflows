# trace generated using paraview version 5.10.0-RC1

#### import the simple module from the paraview
from paraview.simple import *
import os

if os.path.exists("_results"):
        os.system("rm -r _results")
os.mkdir("_results")
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# create a new 'Legacy VTK Reader'
pAKF000 = LegacyVTKReader(registrationName='PAKF000*',FileNames=sys.argv[1:])
# get animation scene
animationScene1 = GetAnimationScene()

# update animation scene based on data timesteps
animationScene1.UpdateAnimationUsingDataTimeSteps()

# set active source
SetActiveSource(pAKF000)

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
pAKF000Display = Show(pAKF000, renderView1, 'UnstructuredGridRepresentation')

# get color transfer function/color map for 'Pressures'
pressuresLUT = GetColorTransferFunction('Pressures')
pressuresLUT.RGBPoints = [-0.08333177864551544, 0.231373, 0.298039, 0.752941, 0.5670134648680687, 0.865003, 0.865003, 0.865003, 1.2173587083816528, 0.705882, 0.0156863, 0.14902]
pressuresLUT.ScalarRangeInitialized = 1.0

# get opacity transfer function/opacity map for 'Pressures'
pressuresPWF = GetOpacityTransferFunction('Pressures')
pressuresPWF.Points = [-0.08333177864551544, 0.0, 0.5, 0.0, 1.2173587083816528, 1.0, 0.5, 0.0]
pressuresPWF.ScalarRangeInitialized = 1

# trace defaults for the display properties.
pAKF000Display.Representation = 'Surface'
pAKF000Display.ColorArrayName = ['POINTS', 'Pressures']
pAKF000Display.LookupTable = pressuresLUT
pAKF000Display.OSPRayScaleArray = 'Pressures'
pAKF000Display.OSPRayScaleFunction = 'PiecewiseFunction'
pAKF000Display.SelectOrientationVectors = 'velocities'
pAKF000Display.ScaleFactor = 8.74416847229004
pAKF000Display.SelectScaleArray = 'Pressures'
pAKF000Display.GlyphType = 'Arrow'
pAKF000Display.GlyphTableIndexArray = 'Pressures'
pAKF000Display.GaussianRadius = 0.43720842361450196
pAKF000Display.SetScaleArray = ['POINTS', 'Pressures']
pAKF000Display.ScaleTransferFunction = 'PiecewiseFunction'
pAKF000Display.OpacityArray = ['POINTS', 'Pressures']
pAKF000Display.OpacityTransferFunction = 'PiecewiseFunction'
pAKF000Display.DataAxesGrid = 'GridAxesRepresentation'
pAKF000Display.PolarAxes = 'PolarAxesRepresentation'
pAKF000Display.ScalarOpacityFunction = pressuresPWF
pAKF000Display.ScalarOpacityUnitDistance = 11.229464521073028

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
pAKF000Display.ScaleTransferFunction.Points = [-0.08333177864551544, 0.0, 0.5, 0.0, 1.2173587083816528, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
pAKF000Display.OpacityTransferFunction.Points = [-0.08333177864551544, 0.0, 0.5, 0.0, 1.2173587083816528, 1.0, 0.5, 0.0]

# show color bar/color legend
pAKF000Display.SetScalarBarVisibility(renderView1, True)

# get the material library
materialLibrary1 = GetMaterialLibrary()

# reset view to fit data
renderView1.ResetCamera()

pressureLUTColorBar = GetScalarBar(pressuresLUT, renderView1)

#pressureLUTColorBar.WindowLocation = 'AnyLocation'

pressureLUTColorBar.Position = [0.7331711273317113, 0.2951388888888889]
pressureLUTColorBar.ScalarBarLength = 0.33
pressureLUTColorBar.LabelFontSize = 5
pressureLUTColorBar.TitleFontSize = 5

pressuresLUT.ApplyPreset('Rainbow Desaturated', True)

# get layout
layout1 = GetLayout()

# layout/tab size in pixels

# current camera placement for renderView1
renderView1.CameraPosition = [-1.2808392299125353, 22.925359773092094, -193.8032920136537]
renderView1.CameraFocalPoint = [-6.3682498931884615, 0.03980827331542427, 14.330472946166989]
renderView1.CameraViewUp = [0.7844697955889284, 0.6140772751759338, 0.08669625090605439]
renderView1.CameraParallelScale = 54.20964394950776

# save animation
SaveAnimation(os.path.join("_results",'pressures-fluid.ogv'), renderView1, ImageResolution=[1920, 1080],
    FrameWindow=[0, 10])

