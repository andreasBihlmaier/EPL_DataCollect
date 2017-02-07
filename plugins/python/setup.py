from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

#Plugin Wrapper
setup(
	name = 'Plugin',
	ext_modules = [ 
		Extension("Plugin",
           		sources=["Plugin.pyx"],  # additional source file(s)
           		language="c++"),             # generate C++ code
      	],
	cmdclass = {'build_ext': build_ext}
)

#Backend API
setup(
  name = 'PluginAPI',
  ext_modules=[
    Extension('PluginAPI', ['PluginAPI.pyx'])
    ],
  cmdclass = {'build_ext': build_ext}
)

#GUI API
setup(
  name = 'PluginGUIAPI',
  ext_modules=[
    Extension('PluginGUIAPI', ['PluginGUIAPI.pyx'])
    ],
  cmdclass = {'build_ext': build_ext}
)

#Wrapper for Cycle class
extension = [Extension('Cycle',
			sources = [ 'Cycle.pyx' ],
			include_dirs = ['../../include', '../../dataCollect/events', '../../external/plf_colony', '../../dataCollect/model'],
			extra_compile_args = [ '-std=c++14' ],
			extra_link_args = ["-L../../dataCollect/model"],
			language = 'c++',)
]

#Wrapper for Cycle class
setup(ext_modules = cythonize(extension))

