project "GLFW"
    language "C"
    kind "StaticLib"
    staticruntime "off"

    architecture "x86_64"

    targetdir ("%{prj.location}/bin/" .. outputdir)
    objdir ("%{prj.location}/bin-int/" .. outputdir)

    files 
    {
        "include/GLFW/glfw3.h",
        "include/GLFW/glfw3native.h",
        "src/vulkan.c",
        "src/monitor.c",
        "src/init.c",
        "src/input.c",
        "src/context.c",
        "src/internal.h",
        "src/window.c"
    }

    filter "system:windows"
        systemversion "latest"

        files
        {
            "src/win32_init.c",
            "src/win32_joystick.c",
            "src/win32_joystick.h",
            "src/win32_monitor.c",
            "src/win32_platform.h",
            "src/win32_platform.h",
            "src/win32_thread.c",
            "src/win32_time.c",
            "src/win32_time.c",
            "src/win32_window.c",
            "src/wgl_context.c",
            "src/wgl_context.h",
            "src/egl_context.c",
            "src/egl_context.h",
            "src/osmesa_context.c",
            "src/osmesa_context.h"
        }

        defines
        {
            "_GLFW_WIN32",
            "_CRT_SECURE_NO_WARNINGS"
        }

    filter "system:linux"
        systemversion "latest"

        files 
        {
            "src/x11_platform.h",
            "src/xkb_unicode.h",
            "src/posix_time.h",
            "src/posix_thread.h",
            "src/glx_context.h",
            "src/egl_context.h",
            "src/osmesa_context.h",
            "src/x11_init.c",
            "src/x11_monitor.c",
            "src/x11_window.c",
            "src/xkb_unicode.c",
            "src/posix_time.c",
            "src/posix_thread.c",
            "src/glx_context.c",
            "src/egl_context.c",
            "src/osmesa_context.c",
            "src/linux_joystick.h",
            "src/linux_joystick.c",
        }

        defines
        {
            "_GLFW_X11",
            "_CRT_SECURE_NO_WARNINGS"
        }

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"
    filter "configurations:Release"
        runtime "Release"
        optimize "on"
