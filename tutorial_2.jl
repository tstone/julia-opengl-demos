import GLFW

using OpenGL
@OpenGL.version "1.0"
@OpenGL.load

function initGL(w, h)
    aspect_ratio = h / w

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0, (1 / aspect_ratio), 0.1, 100.0)
    glMatrixMode(GL_MODELVIEW)

    # smooth shading
    glShadeModel(GL_SMOOTH)
    # black background
    glClearColor(0.0, 0.0, 0.0, 0.0)
    # setup depth buffer
    glClearDepth(1.0)
    # enable depth testing and set type
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LEQUAL)
    #  Really Nice Perspective Calculations
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
end

function draw()
    # clear the screen and depth buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    # reset the current Modelview matrix
    glLoadIdentity()

    # set the color to white
    glColor(1.0, 1.0, 1.0)

    glTranslate(-1.5, 0.0, -6.0)

    glBegin(GL_TRIANGLES)
      glVertex(0.0, 1.0, 0.0)
      glVertex(1.0, -1.0, 0.0)
      glVertex(-1.0, -1.0, 0.0)
    glEnd()

    glTranslate(3.0, 0.0, 0.0)

    glBegin(GL_QUADS)
        glVertex(-1.0, 1.0, 0.0)
        glVertex(1.0, 1.0, 0.0)
        glVertex(1.0, -1.0, 0.0)
        glVertex(-1.0, -1.0, 0.0)
    glEnd()

    glLoadIdentity()
end

function main()
    width = 800
    height = 600
    GLFW.Init()

    window = GLFW.CreateWindow(width, height, "Tutorial 2")
    GLFW.MakeContextCurrent(window)
    GLFW.SetInputMode(window, GLFW.STICKY_KEYS, 1)
    initGL(width, height)

    while !GLFW.WindowShouldClose(window) && !GLFW.GetKey(window, GLFW.KEY_ESCAPE)
        draw()
        GLFW.SwapBuffers(window)
	      GLFW.PollEvents()
    end

    GLFW.Terminate()
end

main()
