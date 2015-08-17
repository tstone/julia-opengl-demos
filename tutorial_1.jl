import GLFW

const OpenGLver="1.0"
using OpenGL

function main()
    width = 800
    height = 600
    GLFW.Init()

    window = GLFW.CreateWindow(width, height, "Tutorial 1")
    GLFW.MakeContextCurrent(window)
    GLFW.SetInputMode(window, GLFW.STICKY_KEYS, 1)

    while !GLFW.WindowShouldClose(window) && !GLFW.GetKey(window, GLFW.KEY_ESCAPE)
        # nothing to draw here
        GLFW.SwapBuffers(window)
	      GLFW.PollEvents()
    end

    GLFW.Terminate()
end

main()
