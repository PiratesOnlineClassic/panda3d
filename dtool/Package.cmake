#
# ------------ Python ------------
#

set(WANT_PYTHON_VERSION ""
  CACHE STRING "Which Python version to seek out for building Panda3D against.")

find_package(Python ${WANT_PYTHON_VERSION} QUIET COMPONENTS Interpreter Development)

if(Python_FOUND)
  set(PYTHON_FOUND ON)
  set(PYTHON_EXECUTABLE ${Python_EXECUTABLE})
  set(PYTHON_INCLUDE_DIRS ${Python_INCLUDE_DIRS})
  set(PYTHON_VERSION_STRING ${Python_VERSION})
else()
  find_package(PythonInterp ${WANT_PYTHON_VERSION} QUIET)
  find_package(PythonLibs ${PYTHON_VERSION_STRING} QUIET)

  if(PYTHONLIBS_FOUND)
    set(PYTHON_FOUND ON)

    if(NOT PYTHON_VERSION_STRING)
      set(PYTHON_VERSION_STRING ${PYTHONLIBS_VERSION_STRING})
    endif()
  endif()
endif()

package_option(PYTHON
  DEFAULT ON
  "Enables support for Python.  If INTERROGATE_PYTHON_INTERFACE
is also enabled, Python bindings will be generated."
  IMPORTED_AS Python::Python)

# Also detect the optimal install paths:
if(HAVE_PYTHON)
  if(WIN32 AND NOT CYGWIN)
    set(_LIB_DIR ".")
    set(_ARCH_DIR ".")
  elseif(PYTHON_EXECUTABLE)
    execute_process(
      COMMAND ${PYTHON_EXECUTABLE}
        -c "from distutils.sysconfig import get_python_lib; print(get_python_lib(False))"
      OUTPUT_VARIABLE _LIB_DIR
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(
      COMMAND ${PYTHON_EXECUTABLE}
        -c "from distutils.sysconfig import get_python_lib; print(get_python_lib(True))"
      OUTPUT_VARIABLE _ARCH_DIR
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  else()
    set(_LIB_DIR "")
    set(_ARCH_DIR "")
  endif()


  execute_process(
    COMMAND ${PYTHON_EXECUTABLE}
      -c "from sysconfig import get_config_var as g; print((g('EXT_SUFFIX') or g('SO'))[:])"
    OUTPUT_VARIABLE _EXT_SUFFIX
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  if(NOT _EXT_SUFFIX)
    if(CYGWIN)
      set(_EXT_SUFFIX ".dll")
    elseif(WIN32)
      set(_EXT_SUFFIX ".pyd")
    else()
      set(_EXT_SUFFIX ".so")
    endif()
  endif()

  set(PYTHON_LIB_INSTALL_DIR "${_LIB_DIR}" CACHE STRING
    "Path to the Python architecture-independent package directory.")

  set(PYTHON_ARCH_INSTALL_DIR "${_ARCH_DIR}" CACHE STRING
    "Path to the Python architecture-dependent package directory.")

  set(PYTHON_EXTENSION_SUFFIX "${_EXT_SUFFIX}" CACHE STRING
    "Suffix for Python binary extension modules.")
endif()

#
# ------------ Eigen ------------
#
find_package(Eigen3 QUIET)

package_option(EIGEN
  "Enables experimental support for the Eigen linear algebra library.
If this is provided, Panda will use this library as the fundamental
implementation of its own linmath library; otherwise, it will use
its own internal implementation.  The primary advantage of using
Eigen is SSE2 support, which is only activated if LINMATH_ALIGN
is also enabled."
  FOUND_AS EIGEN3
  LICENSE "MPL-2")

option(LINMATH_ALIGN
  "This is required for activating SSE2 support using Eigen.
Activating this does constrain most objects in Panda to 16-byte
alignment, which could impact memory usage on very-low-memory
platforms.  Currently experimental." ON)

if(LINMATH_ALIGN)
  package_status(EIGEN "Eigen linear algebra library" "vectorization enabled in build")
else()
  package_status(EIGEN "Eigen linear algebra library" "vectorization NOT enabled in build")
endif()

#
# ------------ OpenSSL ------------
#
find_package(OpenSSL COMPONENTS SSL Crypto QUIET)

package_option(OPENSSL
  DEFAULT ON
  "Enable OpenSSL support"
  IMPORTED_AS OpenSSL::SSL OpenSSL::Crypto)

option(REPORT_OPENSSL_ERRORS
  "Define this true to include the OpenSSL code to report verbose
error messages when they occur." ${IS_DEBUG_BUILD})

if(REPORT_OPENSSL_ERRORS)
  package_status(OPENSSL "OpenSSL" "with verbose error reporting")
else()
  package_status(OPENSSL "OpenSSL")
endif()

#
# ------------ IMAGE FORMATS ------------
#

# JPEG:
find_package(JPEG QUIET)
package_option(JPEG DEFAULT ON "Enable support for loading .jpg images.")
package_status(JPEG "libjpeg")

# PNG:
find_package(PNG QUIET)
package_option(PNG
  DEFAULT ON
  "Enable support for loading .png images."
  IMPORTED_AS PNG::PNG)
package_status(PNG "libpng")

# TIFF:
find_package(TIFF QUIET)
package_option(TIFF "Enable support for loading .tif images.")
package_status(TIFF "libtiff")

# OpenEXR:
find_package(OpenEXR QUIET)
package_option(OPENEXR "Enable support for loading .exr images.")
package_status(OPENEXR "OpenEXR")

#
# ------------ LIBTAR ------------
#
find_package(Tar QUIET)
package_option(TAR
  "This is used to optimize patch generation against tar files.")
package_status(TAR "libtar")

#
# ------------ FFTW ------------
#

find_package(FFTW3 QUIET)

package_option(FFTW
  "This enables support for compression of animations in .bam files.
  This is only necessary for creating or reading .bam files containing
  compressed animations."
  FOUND_AS "FFTW3"
  LICENSE "GPL")

package_status(FFTW "FFTW")

#
# ------------ libsquish ------------
#

find_package(LibSquish QUIET)

package_option(SQUISH
  "Enables support for automatic compression of DXT textures."
  FOUND_AS LIBSQUISH)

package_status(SQUISH "libsquish")

#
# ------------ Nvidia Cg ------------
#

find_package(Cg QUIET)

package_option(CG
  "Enable support for Nvidia Cg Shading Language"
  LICENSE "Nvidia")
package_option(CGGL
  "Enable support for Nvidia Cg's OpenGL API."
  LICENSE "Nvidia")
package_option(CGD3D9
  "Enable support for Nvidia Cg's Direct3D 9 API."
  LICENSE "Nvidia")

if(HAVE_CGGL AND HAVE_CGD3D9)
  set(cg_apis "supporting OpenGL and Direct3D 9")
elseif(HAVE_CGGL)
  set(cg_apis "supporting OpenGL")
elseif(HAVE_CGDX9)
  set(cg_apis "supporting Direct3D 9")
else()
  set(cg_apis "WITHOUT rendering backend support")
endif()
package_status(CG "Nvidia Cg Shading Language" "${cg_apis}")

#
# ------------ VRPN ------------
#

find_package(VRPN QUIET)

package_option(VRPN
  "Enables support for connecting to VRPN servers. This is only needed if you
  are building Panda3D for a fixed VRPN-based VR installation.")

package_status(VRPN "VRPN")

#
# ------------ zlib ------------
#

find_package(zlib QUIET)

package_option(ZLIB
  "Enables support for compression of Panda assets."
  IMPORTED_AS ZLIB::ZLIB)

package_status(ZLIB "zlib")

#
# ------------ FFmpeg ------------
#

find_package(FFMPEG QUIET)
find_package(SWScale QUIET)
find_package(SWResample QUIET)

package_option(FFMPEG
  "Enables support for audio- and video-decoding using the FFmpeg library.")
package_option(SWSCALE
  "Enables support for FFmpeg's libswscale for video rescaling.")
package_option(SWRESAMPLE
  "Enables support for FFmpeg's libresample for audio resampling.")

if(HAVE_SWSCALE AND HAVE_SWRESAMPLE)
  set(ffmpeg_features "with swscale and swresample")
elseif(HAVE_SWSCALE)
  set(ffmpeg_features "with swscale")
elseif(HAVE_SWRESAMPLE)
  set(ffmpeg_features "with swresample")
else()
  set(ffmpeg_features "without resampling/rescaling support")
endif()
package_status(FFMPEG "FFmpeg" "${ffmpeg_features}")

#
# ------------ Audio libraries ------------
#

# Miles Sound System
find_package(Miles QUIET)
package_option(RAD_MSS
  "This enables support for audio output via the Miles Sound System,
  by RAD Game Tools. This requires a commercial license to use, so you'll know
  if you need to enable this option."
  FOUND_AS Miles
  LICENSE "Miles")
package_status(RAD_MSS "Miles Sound System")

# FMOD Ex
find_package(FMODEx QUIET)
package_option(FMODEX
  "This enables support for the FMOD Ex sound library,
  from Firelight Technologies. This audio library is free for non-commercial
  use."
  LICENSE "FMOD")
package_status(FMODEX "FMOD Ex sound library")

# OpenAL
find_package(OpenAL QUIET)
package_option(OPENAL
  "This enables support for audio output via OpenAL. Some platforms, such as
  macOS, provide their own OpenAL implementation, which Panda3D can use. But,
  on most platforms this will imply OpenAL Soft, which is LGPL licensed."
  IMPORTED_AS OpenAL::OpenAL
  LICENSE "LGPL")
package_status(OPENAL "OpenAL sound library")

if(OPENAL_FOUND AND APPLE)
  set(HAVE_OPENAL_FRAMEWORK YES)
endif()


#
# ------------ UI libraries ------------
#

# Freetype

find_package(Freetype QUIET)

package_option(FREETYPE
  "This enables support for the FreeType font-rendering library.  If disabled,
  Panda3D will only be able to read fonts specially made with egg-mkfont."
  IMPORTED_AS freetype)

package_status(FREETYPE "FreeType")

# HarfBuzz

# Some versions of harfbuzz-config.cmake contain an endless while loop, so we
# force MODULE mode here.
find_package(HarfBuzz MODULE QUIET)

package_option(HARFBUZZ
  "This enables support for the HarfBuzz text shaping library."
  IMPORTED_AS harfbuzz::harfbuzz)

package_status(HARFBUZZ "HarfBuzz")

# GTK2

# Find and configure GTK
set(Freetype_FIND_QUIETLY TRUE) # Fix for builtin FindGTK2
set(GTK2_GTK_FIND_QUIETLY TRUE) # Fix for builtin FindGTK2
find_package(GTK2 QUIET COMPONENTS gtk)
package_option(GTK2)
package_status(GTK2 "gtk+-2")

#
# ------------ Physics engines ------------
#

# Bullet
find_package(Bullet MODULE QUIET)

package_option(BULLET
  "Enable this option to support game dynamics with the Bullet physics library.")

package_status(BULLET "Bullet physics")

# ODE
find_package(ODE QUIET)

package_option(ODE
  "Enable this option to support game dynamics with the Open Dynamics Engine (ODE)."
  LICENSE "BSD-3"
  IMPORTED_AS ODE::ODE)

package_status(ODE "Open Dynamics Engine")

# PhysX
find_package(PhysX QUIET)

package_option(PHYSX
  "Enable this option to support game dynamics with Nvidia PhysX."
  LICENSE "Nvidia")

package_status(PHYSX "Nvidia PhysX")

#
# ------------ SpeedTree ------------
#

# SpeedTree
find_package(SpeedTree QUIET)

package_option(SPEEDTREE
  "Enable this option to include scenegraph support for SpeedTree trees."
  LICENSE "SpeedTree")

package_status(SPEEDTREE "SpeedTree")

#
# ------------ Rendering APIs ------------
#

# OpenGL
find_package(OpenGL QUIET)

package_option(GL
  "Enable OpenGL support."
  FOUND_AS OPENGL
  IMPORTED_AS OpenGL::GL)

package_status(GL "OpenGL")

# OpenGL ES 1
find_package(OpenGLES1 QUIET)

package_option(GLES1
  "Enable support for OpenGL ES 1.x rendering APIs."
  FOUND_AS OPENGLES1)

package_status(GLES1 "OpenGL ES 1.x")

# OpenGL ES 2
find_package(OpenGLES2 QUIET)

package_option(GLES2
  "Enable support for OpenGL ES 2.x rendering APIs."
  FOUND_AS OPENGLES2)

package_status(GLES2 "OpenGL ES 2.x")

#
# ------------ Display APIs ------------
#

# X11
find_package(X11 QUIET)

if(NOT X11_Xkb_FOUND OR NOT X11_Xutil_FOUND)
  # Panda implicitly requires these supplementary X11 libs; if we can't find
  # them, we just say we didn't find X11 at all.
  set(X11_FOUND OFF)
endif()

package_option(X11
  "Provides X-server support on Unix platforms. X11 may need to be linked
against for tinydisplay, but probably only on a Linux platform.")

set(HAVE_GLX_AVAILABLE OFF)
if(HAVE_GL AND HAVE_X11 AND NOT APPLE)
  set(HAVE_GLX_AVAILABLE ON)
endif()

option(HAVE_GLX "Enables GLX. Requires OpenGL and X11." ${HAVE_GLX_AVAILABLE})
if(HAVE_GLX AND NOT HAVE_GLX_AVAILABLE)
  message(SEND_ERROR "HAVE_GLX manually set to ON but it is not available!")
endif()

if(HAVE_GLX)
  package_status(X11 "X11" "with GLX")
else()
  package_status(X11 "X11" "without GLX")
endif()

# EGL
find_package(EGL QUIET)

package_option(EGL
  "Enable support for the Khronos EGL context management interface for
  OpenGL ES.  This is necessary to support OpenGL ES under X11.")

package_status(EGL "EGL")

# Direct3D 9

find_package(Direct3D9 QUIET COMPONENTS dxguid dxerr d3dx9)

package_option(DX9
  "Enable support for DirectX 9.  This is typically only viable on Windows."
  FOUND_AS DIRECT3D9)

package_status(DX9 "Direct3D 9.x")

#
# ------------ Vision tools ------------
#

# OpenCV
find_package(OpenCV QUIET COMPONENTS core highgui)

package_option(OPENCV
  "Enable support for OpenCV.  This will be built into the 'vision' package."
  FOUND_AS OpenCV)

package_status(OPENCV "OpenCV")

# ARToolKit
find_package(ARToolKit QUIET)

package_option(ARTOOLKIT
  "Enable support for ARToolKit.  This will be built into the 'vision' package.")

package_status(ARTOOLKIT "ARToolKit")

########
# TODO #
########

# Find and configure Awesomium
#find_package(Awesomium)
#package_status(AWESOMIUM COMMENT "Awesomium")

# Find and configure OpenMaya
#find_package(OpenMaya)
#package_status(MAYA COMMENT "OpenMaya")

# Find and configure FCollada
#find_package(FCollada)
#package_status(FCOLLADA COMMENT "FCollada")
#if(FOUND_COLLADA14DOM OR FOUND_COLLADA15DOM)
# set(USE_COLLADA TRUE CACHE BOOL "If true, compile Panda3D with COLLADA DOM")
# if(USE_COLLADA)
#   if(FOUND_COLLADA15DOM)
#     set(HAVE_COLLADA15DOM TRUE)
#   else()
#     set(HAVE_COLLADA14DOM TRUE)
#   endif()
# endif()
#endif()

# Find and configure Assimp
#find_package(Assimp)
#package_status(ASSIMP COMMENT "Assimp")

# Find and configure libRocket
#find_package(Rocket)
#package_status(ROCKET COMMENT "libRocket")
#if(HAVE_ROCKET AND HAVE_PYTHON)
# # Check for rocket python bindings
# if(FOUND_ROCKET_PYTHON)
#   option(USE_ROCKET_PYTHON "If on, compile Panda3D with python bindings for libRocket" ON)
#   if(USE_ROCKET_PYTHON)
#     set(HAVE_ROCKET_PYTHON TRUE)
#   endif()
#   else()
#       unset(USE_ROCKET_PYTHON CACHE)
# endif()
# if(HAVE_ROCKET_PYTHON)
#   message(STATUS "+ libRocket with Python bindings")
# else()
#   message(STATUS "+ libRocket without Python bindings")
# endif()
#else()
# unset(USE_ROCKET_PYTHON CACHE)
#endif()

# Find and configure Vorbis
#find_package(Vorbis)
#package_status(VORBIS COMMENT "Vorbis Ogg decoder")