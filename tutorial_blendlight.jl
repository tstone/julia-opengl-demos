using GLFW
using OpenGL
@OpenGL.version "1.0"
@OpenGL.load

immutable WorldState
    x_rot::GLfloat
    x_speed::GLfloat
    y_rot::GLfloat
    y_speed::GLfloat

    WorldState(xr, xs, yr, ys) = new(xr, xs, yr, ys)
    WorldState() = new(0.0, 0.0, 0.0, 0.0)
end


function tick(window::GLFW.Window, state::WorldState)
    x_speed = state.x_speed
    x_speed += GLFW.GetKey(window, GLFW.KEY_UP) ? 0.04 : 0.0
    x_speed -= GLFW.GetKey(window, GLFW.KEY_DOWN) ? 0.04 : 0.0
    y_speed = state.y_speed
    y_speed += GLFW.GetKey(window, GLFW.KEY_RIGHT) ? 0.04 : 0.0
    y_speed -= GLFW.GetKey(window, GLFW.KEY_LEFT) ? 0.04 : 0.0
    x_rot = state.x_rot + x_speed
    y_rot = state.y_rot + y_speed
    return WorldState(x_rot, x_speed,
                      y_rot, y_speed)
end

function initGL(w, h)
    aspect_ratio = w / h

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0, aspect_ratio, 0.1, 100.0)

    glMatrixMode(GL_MODELVIEW)

    # smooth shading
    glShadeModel(GL_SMOOTH)
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glEnable(GL_CULL_FACE)
    glEnable(GL_COLOR_MATERIAL)
    #  Really Nice Perspective Calculations
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

    # white background
    glClearColor(1.0, 1.0, 1.0, 1.0)
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LEQUAL)
    glClearDepth(1.0)
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
end

function draw_cube(flip_normal=false)
    glPushMatrix()
    # 4 sides
    for rot in [0, 90, 180, 270]
        glPushMatrix()
            glRotate(rot, 0.0, 1.0, 0.0)
            glTranslate(0.0, 0.0, 1.0)
            draw_square(flip_normal)
        glPopMatrix()
    end
    #top, bottom
    for rot in [90, 270]
        glPushMatrix()
            glRotate(rot, 1.0, 0.0, 0.0)
            glTranslate(0.0, 0.0, 1.0)
            draw_square(flip_normal)
        glPopMatrix()
    end
    glPopMatrix()
end

function draw_square(flip_normal=false)
    glBegin(GL_QUADS);
        glNormal(0.0, 0.0, flip_normal ? -1.0 : 1.0)
        glVertex(-1.0, -1.0,  0.0)
        glVertex( 1.0, -1.0,  0.0)
        glVertex( 1.0,  1.0,  0.0)
        glVertex(-1.0,  1.0,  0.0)
    glEnd()
end

function draw(state)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    # reset the current Modelview matrix
    glLoadIdentity()

    glTranslate(0.0, 0.0, -6.0)
    glRotate(state.x_rot, 1.0, 0.0, 0.0)
    glRotate(state.y_rot, 0.0, 1.0, 0.0)

    # first draw the opaque cube, so the depth buffer will reject anything
    # behind it
    glColor(0.0, 1.0, 0.0, 1.0)
    glPushMatrix()
    glTranslate(-1.5, 0.0, 0.0)
    draw_cube()
    glPopMatrix()

    glColor(1.0, 0.0, 0.0, 0.25)
    glPushMatrix()
    glTranslate(1.5, 0.0, 0.0)
    # now we draw the back faces of the transparent cube. We flip the normals
    # so that the lighting model treats the suface as facing us
    glCullFace(GL_FRONT)
    draw_cube(true)
    # and then the front
    glCullFace(GL_BACK)
    draw_cube()
    glPopMatrix()

end

function main()
    width = 800
    height = 600
    GLFW.Init()
    # this time we'll set up anti-aliasing to smooth the edges
    GLFW.WindowHint(GLFW.SAMPLES, 4)
    window = GLFW.CreateWindow(width, height, "Tutorial Blendlight")
    GLFW.MakeContextCurrent(window)
    GLFW.SetInputMode(window, GLFW.STICKY_KEYS, 1)
    initGL(width, height)

    state = WorldState()

    while !GLFW.WindowShouldClose(window) && !GLFW.GetKey(window, GLFW.KEY_ESCAPE)
        draw(state)
        GLFW.SwapBuffers(window)
	      GLFW.PollEvents()
        state = tick(window, state)
    end

    GLFW.Terminate()
end

main()
