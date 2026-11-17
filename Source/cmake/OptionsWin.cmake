if (MSVC)
    include(OptionsMSVC)
endif ()

# Define minimum supported Windows version
# https://msdn.microsoft.com/en-us/library/6sehtctf.aspx
#
# Windows 10 1809 "Redstone 5" NTDDI_WIN10_RS5 (0x0A000006)
# https://learn.microsoft.com/en-us/windows/win32/winprog/using-the-windows-headers?redirectedfrom=MSDN#macros-for-conditional-declarations
#
# Supported versions of Windows client
# https://learn.microsoft.com/en-us/windows/release-health/supported-versions-windows-client
add_definitions(-D_WINDOWS -DNTDDI_VERSION=0x0A000006 -D_WIN32_WINNT=0x0A00)

add_definitions(-DNOMINMAX)
add_definitions(-DUNICODE -D_UNICODE)
add_definitions(-DNOCRYPT)

# For fileno, wcsicmp, getpid and strdup.
# https://learn.microsoft.com/en-us/previous-versions/ms235384(v=vs.100)
add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)

# FIXME: warning STL4042: std::float_denorm_style, std::numeric_limits::has_denorm, and std::numeric_limits::has_denorm_loss are deprecated in C++23.
add_definitions(-D_SILENCE_CXX23_DENORM_DEPRECATION_WARNING)

# If <winsock2.h> is not included before <windows.h> redefinition errors occur
# unless _WINSOCKAPI_ is defined before <windows.h> is included
add_definitions(-D_WINSOCKAPI_=)

set(ENABLE_WEBKIT ON)
set(ENABLE_WEBKIT_LEGACY OFF)

if (DEFINED ENV{WEBKIT_IGNORE_PATH})
    list(APPEND CMAKE_IGNORE_PATH $ENV{WEBKIT_IGNORE_PATH})
endif ()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

find_package(CURL 7.87.0 REQUIRED)
find_package(HarfBuzz 1.4.2 REQUIRED COMPONENTS ICU)
find_package(ICU 70.1 REQUIRED COMPONENTS data i18n uc)
find_package(JPEG 1.5.2 REQUIRED)
find_package(LibXml2 2.9.7 REQUIRED)
find_package(OpenSSL REQUIRED)

# the gstreamer sdk's pc files leak the sdk include root into compile flags later, and that root
# carries bundled openssl, zlib and png headers. put the vcpkg include in front so the libraries
# webkit actually links always win the header search.
add_compile_options(-I${OPENSSL_INCLUDE_DIR})
find_package(PNG 1.6.34 REQUIRED)
find_package(SQLite3 3.23.1 REQUIRED)
find_package(ZLIB 1.2.11 REQUIRED)
find_package(LibPSL 0.20.2 REQUIRED)
find_package(WebP REQUIRED COMPONENTS demux)

if (NOT TARGET SQLite3::SQLite3) # CMake < 4.3
    add_library(SQLite3::SQLite3 ALIAS SQLite::SQLite3)
endif ()

WEBKIT_OPTION_BEGIN()

include(GStreamerDefinitions)

# the sdk's gstgl is wgl only and angle is egl, so the gl video sink cannot work on this port yet
WEBKIT_OPTION_DEFAULT_PORT_VALUE(USE_GSTREAMER_GL PRIVATE OFF)

# gstreamer's shared dependency list refers to these two speech engines, no win backend exists
WEBKIT_OPTION_DEFINE(USE_FLITE "Whether to enable Flite speech synthesis" PRIVATE OFF)
WEBKIT_OPTION_DEFINE(USE_SPIEL "Whether to enable Spiel speech synthesis" PRIVATE OFF)

WEBKIT_OPTION_DEFINE(USE_SKIA_OPENTYPE_SVG "Whether to use the Skia built-in support for OpenType SVG fonts." PUBLIC ON)
WEBKIT_OPTION_DEPEND(USE_SKIA_OPENTYPE_SVG USE_SKIA)

# FIXME: Most of these options should not be public.
# TODO: Audit the features list
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_API_TESTS PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_ATTACHMENT_ELEMENT PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_CURSOR_VISIBILITY PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_DEVICE_ORIENTATION PUBLIC OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_DRAG_SUPPORT PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_FTL_JIT PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_FULLSCREEN_API PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_GAMEPAD PUBLIC OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_GEOLOCATION PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_LAYOUT_TESTS PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MATHML PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MEDIA_SOURCE PUBLIC OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MEDIA_STATISTICS PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MINIBROWSER PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_MOUSE_CURSOR_SCALE PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_PERIODIC_MEMORY_MONITOR PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_VIDEO PUBLIC ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBASSEMBLY PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBASSEMBLY_BBQJIT PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBASSEMBLY_OMGJIT PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBKIT_OVERFLOW_SCROLLING_CSS_PROPERTY PUBLIC OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEB_AUDIO PUBLIC OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_XSLT PUBLIC ON)

WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_SMOOTH_SCROLLING PRIVATE OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBGL PRIVATE OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(USE_AVIF PRIVATE OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(USE_SKIA PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(USE_WOFF2 PRIVATE ON)

# Enabled features
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_DARK_MODE_CSS PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_LEGACY_ENCRYPTED_MEDIA PUBLIC OFF)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_RELEASE_LOG PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_SHAREABLE_RESOURCE PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_USER_MESSAGE_HANDLERS PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBGL PUBLIC ON)

# Formerly experimental features, now enabled by default (the disabled
# configuration is not tested).
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_APPLICATION_MANIFEST PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_GPU_PROCESS PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_REMOTE_INSPECTOR PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_RESOURCE_USAGE PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_VARIATION_FONTS PRIVATE ON)
WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_WEBDRIVER PRIVATE ON)

# No support planned

# WebDriver options
SET_AND_EXPOSE_TO_BUILD(ENABLE_WEBDRIVER_KEYBOARD_INTERACTIONS ON)
SET_AND_EXPOSE_TO_BUILD(ENABLE_WEBDRIVER_MOUSE_INTERACTIONS ON)

include(GStreamerDependencies)

WEBKIT_OPTION_END()

if (USE_GSTREAMER)
    find_package(GLib 2.70.0 REQUIRED COMPONENTS Thread Module Gio)

    # the sdk's pc files put the sdk include root on their cflags, and that root carries bundled
    # copies of openssl, zlib, png and friends that would shadow the vcpkg libraries webkit
    # already links. drop the bare root, keep the glib include dirs.
    foreach (_glib_target GLib::GLib GLib::Object GLib::Thread GLib::Module GLib::Gio)
        if (TARGET ${_glib_target})
            get_target_property(_glib_include_dirs ${_glib_target} INTERFACE_INCLUDE_DIRECTORIES)
            if (_glib_include_dirs)
                list(FILTER _glib_include_dirs EXCLUDE REGEX "msvc_x86_64/include$")
                set_target_properties(${_glib_target} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${_glib_include_dirs}")
            endif ()

            # findglib also pushes the raw cflags onto the interface, and those carry the include
            # dirs as -I compile options, which is where the sdk root sneaks back in. the include
            # dirs are already set above, the flags carry nothing needed on windows.
            set_target_properties(${_glib_target} PROPERTIES INTERFACE_COMPILE_OPTIONS "")
        endif ()
    endforeach ()

    # the shared gstreamer cmake links GLib::GioUnix, which does not exist here because the sdk
    # ships gio-2.0 and gio-windows-2.0 but no gio-unix-2.0, point the target at plain gio
    if (NOT TARGET GLib::GioUnix)
        add_library(GLib::GioUnix INTERFACE IMPORTED)
        set_target_properties(GLib::GioUnix PROPERTIES INTERFACE_LINK_LIBRARIES GLib::Gio)
    endif ()
endif ()

set(USE_ANGLE_EGL ON)

SET_AND_EXPOSE_TO_BUILD(USE_ANGLE ON)
SET_AND_EXPOSE_TO_BUILD(USE_CURL ON)
SET_AND_EXPOSE_TO_BUILD(USE_GRAPHICS_LAYER_TEXTURE_MAPPER ON)
SET_AND_EXPOSE_TO_BUILD(USE_GRAPHICS_LAYER_WC ON)
SET_AND_EXPOSE_TO_BUILD(USE_HARFBUZZ ON)
SET_AND_EXPOSE_TO_BUILD(USE_OPENSSL ON)
SET_AND_EXPOSE_TO_BUILD(USE_TEXTURE_MAPPER ON)
SET_AND_EXPOSE_TO_BUILD(USE_THEME_ADWAITA ON)
if (USE_GSTREAMER)
    SET_AND_EXPOSE_TO_BUILD(USE_MEDIA_FOUNDATION OFF)
else ()
    SET_AND_EXPOSE_TO_BUILD(USE_MEDIA_FOUNDATION ${ENABLE_VIDEO})
endif ()
SET_AND_EXPOSE_TO_BUILD(USE_INSPECTOR_SOCKET_SERVER ${ENABLE_REMOTE_INSPECTOR})
SET_AND_EXPOSE_TO_BUILD(HAVE_GL_FENCE ON)
SET_AND_EXPOSE_TO_BUILD(ENABLE_DEVELOPER_MODE ${DEVELOPER_MODE})

# See if OpenSSL implementation is BoringSSL
cmake_push_check_state()
set(CMAKE_REQUIRED_INCLUDES "${OPENSSL_INCLUDE_DIR}")
set(CMAKE_REQUIRED_LIBRARIES "${OPENSSL_LIBRARIES}")
WEBKIT_CHECK_HAVE_SYMBOL(USE_BORINGSSL OPENSSL_IS_BORINGSSL openssl/ssl.h)
cmake_pop_check_state()

if (ENABLE_XSLT)
    find_package(LibXslt 1.1.32 REQUIRED)
endif ()

if (USE_AVIF)
    find_package(AVIF 0.9.0)
    if (NOT AVIF_FOUND)
        message(FATAL_ERROR "libavif 0.9.0 is required for USE_AVIF.")
    endif ()
endif ()

if (USE_LCMS)
    find_package(LCMS2)
    if (NOT LCMS2_FOUND)
        message(FATAL_ERROR "libcms2 is required for USE_LCMS.")
    endif ()
endif ()

if (USE_JPEGXL)
    find_package(JPEGXL 0.7.0)
    if (NOT JPEGXL_FOUND)
        message(FATAL_ERROR "libjxl is required for USE_JPEGXL")
    endif ()
endif ()

if (USE_SKIA)
    find_package(HarfBuzz 1.4.2 REQUIRED COMPONENTS ICU)
    find_library(SHARPYUV_LIBS libsharpyuv)

    SET_AND_EXPOSE_TO_BUILD(USE_HARFBUZZ ON)
else ()
    find_package(Cairo 1.18.0 REQUIRED)
    SET_AND_EXPOSE_TO_BUILD(USE_CAIRO ON)
endif ()

if (USE_WOFF2)
    find_package(WOFF2 1.0.2 COMPONENTS dec)
    if (NOT WOFF2_FOUND)
        message(FATAL_ERROR "libwoff2dec is required for USE_WOFF2")
    endif ()
    find_package(Brotli REQUIRED COMPONENTS dec)
endif ()

set(bmalloc_LIBRARY_TYPE OBJECT)
set(WTF_LIBRARY_TYPE OBJECT)
set(JavaScriptCore_LIBRARY_TYPE SHARED)
set(PAL_LIBRARY_TYPE OBJECT)
set(WebCore_LIBRARY_TYPE OBJECT)
set(WebCoreTestSupport_LIBRARY_TYPE OBJECT)

include(GStreamerChecks)

# the gstreamer pc files pull the sdk include root in through their requires, and that root
# carries bundled openssl, zlib and png headers that would shadow the vcpkg libraries webkit
# already links against. strip the bare root from every component include list.
foreach (_gst_include_var
    GSTREAMER_INCLUDE_DIRS
    GSTREAMER_BASE_INCLUDE_DIRS
    GSTREAMER_ALLOCATORS_INCLUDE_DIRS
    GSTREAMER_APP_INCLUDE_DIRS
    GSTREAMER_AUDIO_INCLUDE_DIRS
    GSTREAMER_FFT_INCLUDE_DIRS
    GSTREAMER_GL_INCLUDE_DIRS
    GSTREAMER_MPEGTS_INCLUDE_DIRS
    GSTREAMER_PBUTILS_INCLUDE_DIRS
    GSTREAMER_TAG_INCLUDE_DIRS
    GSTREAMER_VIDEO_INCLUDE_DIRS)
    if (DEFINED ${_gst_include_var})
        list(FILTER ${_gst_include_var} EXCLUDE REGEX "msvc_x86_64/include$")
    endif ()
endforeach ()
