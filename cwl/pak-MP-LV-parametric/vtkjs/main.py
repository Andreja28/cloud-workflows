import vtkmodules.all as vtk
# import vtk
import sys, os
# print(sys.argv)

os.mkdir("_results")
if (len(sys.argv) >1  ):
    # print(os.listdir())
    # print("-----------------------")
    # print(sys.argv)
    colors = vtk.vtkNamedColors()
    problemName = (sys.argv[1].split("/")[-1]).split("0")[0]
    # problemName = sys.argv[1].split("-")[0]
    # print(problemName)
    # print(os.listdir())

    # numberOfTimeSteps = len([name for name in os.listdir() if os.path.isfile(os.path.join(sys.argv[1], name)) and name.endswith(".vtk")])
    # print(numberOfTimeSteps)
    file_prefix = problemName+"_"
    # file_prefix = "heart-vtk/heart_"
    os.mkdir("animation")

    rootIndexData = {
        "version": 1.0,
        "background": [ ],
        "camera": { },
        "centerOfRotation": { },
        "scene": [ ],
        "lookupTables": { },
        "animation": {
            "type": "vtkTimeStepBasedAnimationHandler",
            "timeSteps": []
        }
    }
    i=0
    for file_name in sys.argv[1:]:
        # file_name = file_prefix+str(i)+"/"+problemName+"_"+str(i)+"_0_0.vtu"
        # print(sys.argv[1])
        # print(file_prefix+str(i)+".vtk")
        print(file_name)
        # file_name = os.path.join(sys.argv[1],file_prefix+str(i)+".vtk")
        # print(file_name)
        # vtkReader = vtkIOLegacy.vtkUnstructuredGridReader()
        # vtkReader.SetFileName('vtks/PAKF00001.vtk')

        # vtkReader.Update()

        # points = vtkReader.GetOutput()
        # print(points)

        reader = vtk.vtkUnstructuredGridReader()
        # reader = vtk.vtkPolyDataReader()
        # reader = vtk.vtkXMLUnstructuredGridReader()
        reader.SetFileName(file_name)

        reader.ReadAllScalarsOn()
        reader.ReadAllVectorsOn()
          # Needed because of GetScalarRange
        # reader.UpdateTimeStep(i-1)
        reader.Update()

        # if (int(sys.argv[1])< 10):
        #     file_name = file_prefix+"0"+sys.argv[1]+".vtk"
        # else:
        #     file_name = file_prefix+sys.argv[1]+".vtk"
        # reader = vtk.vtkUnstructuredGridReader()
        # reader.SetFileName(file_name)
        # reader.ReadAllScalarsOn()
        # reader.ReadAllVectorsOn()
        # reader.Update()
        output = reader.GetOutput()

        vtkGeomFil = vtk.vtkGeometryFilter()
        vtkGeomFil.SetInputData(output)
        vtkGeomFil.Update()

        # scalar_range = output.GetScalarRange()

        # Create the mapper that corresponds the objects of the vtk.vtk file
        # into graphics elements
        mapper = vtk.vtkPolyDataMapper()
        mapper.SetInputData(vtkGeomFil.GetOutput())
        # mapper.SetScalarRange(scalar_range)
        mapper.ScalarVisibilityOff()

        # Create the Actor
        actor = vtk.vtkActor()
        actor.SetMapper(mapper)
        actor.GetProperty().EdgeVisibilityOn()
        actor.GetProperty().SetLineWidth(2.0)
        actor.GetProperty().SetColor(colors.GetColor3d("MistyRose"))
        backface = vtk.vtkProperty()
        backface.SetColor(colors.GetColor3d('Tomato'))
        actor.SetBackfaceProperty(backface)

        # Create the Renderer
        renderer = vtk.vtkRenderer()
        renderer.AddActor(actor)
        renderer.SetBackground(colors.GetColor3d('Wheat'))

        # Create the RendererWindow
        renderer_window = vtk.vtkRenderWindow()
        renderer_window.SetSize(640, 480)
        renderer_window.AddRenderer(renderer)
        renderer_window.SetWindowName('ReadUnstructuredGrid')

        # print(renderer_window)

        # interactor = vtk.vtkRenderWindowInteractor()
        # interactor.SetRenderWindow(renderer_window)
        # interactor.Initialize()
        # interactor.Start()
        # import time
        # time.sleep(2)


        exporter=vtk.vtkJSONSceneExporter()
        exporter.SetFileName('animation/'+str(i))
        exporter.SetInput(renderer_window)
        # exporter.SetActiveRenderer(renderer_window.getRenderer())
        exporter.Write()

        rootIndexData["animation"]["timeSteps"].append({"time":float(i)})
        i=i+1

    import json

    with open(os.path.join("animation",'index.json'), 'w') as outfile:
        json.dump(rootIndexData, outfile)

    import helper as helper

    helper.zipAllTimeSteps("./animation")
    import shutil
    shutil.move(os.path.join("animation", "animation.zip"),os.path.join("_results",problemName+".vtkjs"))

    shutil.rmtree('./animation')

os.chmod("_results", 0o777)