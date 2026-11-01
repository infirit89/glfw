newoption {
    trigger = "linux-display-server",
    value = "server",
    description = "Which Display server to use",
    allowed = {
        { "wayland", "Wayland" },
        { "x11", "X11" },
    },
    default = "X11",
}

local wayland_protocol_dir = "deps/wayland"
local wayland_generated_dir = "%{prj.location}/bin-int/" .. outputdir .. "/wayland"

local protocols = {
    "wayland",
    "viewporter",
    "xdg-shell",
    "idle-inhibit-unstable-v1",
    "pointer-constraints-unstable-v1",
    "relative-pointer-unstable-v1",
    "fractional-scale-v1",
    "xdg-activation-v1",
    "xdg-decoration-unstable-v1",
}

project "GLFW"
language "C"
kind "StaticLib"
staticruntime "off"

targetdir("%{prj.location}/bin/" .. outputdir)
objdir("%{prj.location}/bin-int/" .. outputdir)

files {
    "include/GLFW/glfw3.h",
    "include/GLFW/glfw3native.h",
    "src/vulkan.c",
    "src/monitor.c",
    "src/init.c",
    "src/input.c",
    "src/context.c",
    "src/internal.h",
    "src/window.c",
    "src/platform.c",
    "src/osmesa_context.c",
    "src/osmesa_context.h",
    "src/null_platform.h",
    "src/null_joystick.h",
    "src/null_init.c",
    "src/null_monitor.c",
    "src/null_window.c",
    "src/null_joystick.c",
    "src/egl_context.c",
    "src/egl_context.h",
}

filter "system:windows"
architecture "x86_64"
systemversion "latest"

files {
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
}

defines {
    "_GLFW_WIN32",
    "_CRT_SECURE_NO_WARNINGS",
}

filter { "system:linux", "options:linux-display-server=x11" }
architecture "x86_64"
systemversion "latest"

files {
    "src/x11_platform.h",
    "src/xkb_unicode.h",
    "src/posix_time.h",
    "src/posix_thread.h",
    "src/glx_context.h",
    "src/x11_init.c",
    "src/x11_monitor.c",
    "src/x11_window.c",
    "src/xkb_unicode.c",
    "src/posix_time.c",
    "src/posix_thread.c",
    "src/posix_module.c",
    "src/posix_poll.h",
    "src/posix_poll.c",
    "src/glx_context.c",
    "src/linux_joystick.h",
    "src/linux_joystick.c",
}

defines {
    "_GLFW_X11",
}

filter { "system:linux", "options:linux-display-server=wayland" }
architecture "x86_64"
systemversion "latest"

files {
    "src/wl_platform.h",
    "src/posix_time.h",
    "src/posix_thread.h",
    "src/wl_init.c",
    "src/wl_monitor.c",
    "src/wl_window.c",
    "src/posix_time.c",
    "src/posix_thread.c",
    "src/posix_module.c",
    "src/posix_poll.h",
    "src/posix_poll.c",
    "src/linux_joystick.h",
    "src/linux_joystick.c",
}

for _, protocol in ipairs(protocols) do
    files {
        wayland_generated_dir .. "/" .. protocol .. "-client-protocol-code.h",
    }
end

prebuildcommands {
    "{MKDIR} " .. wayland_generated_dir,

    -- Generate all protocol headers.
    "wayland-scanner client-header "
        .. wayland_protocol_dir
        .. "/wayland.xml "
        .. wayland_generated_dir
        .. "/wayland-client-protocol.h",

    -- Generate all protocol implementations.
    "wayland-scanner private-code "
        .. wayland_protocol_dir
        .. "/wayland.xml "
        .. wayland_generated_dir
        .. "/wayland-client-protocol-code.h",
}

for _, protocol in ipairs(protocols) do
    if protocol ~= "wayland" then
        prebuildcommands {
            "wayland-scanner client-header " ..
                wayland_protocol_dir .. "/" .. protocol .. ".xml " ..
                wayland_generated_dir .. "/" .. protocol .. "-client-protocol.h",

            "wayland-scanner private-code " ..
                wayland_protocol_dir .. "/" .. protocol .. ".xml " ..
                wayland_generated_dir .. "/" .. protocol .. "-client-protocol-code.h",
        }
    end
end

includedirs {
    wayland_generated_dir,
}

defines {
    "_GLFW_WAYLAND",
}

filter "system:macosx"
architecture "ARM64"

files {
    "src/cocoa_init.m",
    "src/cocoa_monitor.m",
    "src/cocoa_window.m",
    "src/cocoa_platform.h",
    "src/cocoa_time.h",
    "src/cocoa_time.c",
    "src/cocoa_joystick.h",
    "src/cocoa_joystick.m",
    "src/posix_thread.h",
    "src/posix_thread.c",
    "src/posix_module.c",
    "src/glx_context.h",
    "src/glx_context.c",
    "src/nsgl_context.m",
}

defines {
    "_GLFW_COCOA",
}

filter "configurations:Debug"
runtime "Debug"
symbols "on"
filter "configurations:Release"
runtime "Release"
optimize "on"
