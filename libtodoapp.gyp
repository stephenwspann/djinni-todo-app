{
  'targets': [
    {
      'target_name': 'libtodoapp_objc',
      'type': 'static_library',
      'conditions': [],
      'dependencies': [
        './deps/djinni/support-lib/support_lib.gyp:djinni_objc',
        './deps/sqlite3.gyp:sqlite3',
      ],
      'sources': [
        '<!@(python deps/djinni/example/glob.py objc *.mm *.h *.m)',
      ],
      'sources!': ['play.m'],
      'include_dirs': [
        'include',
        'objc',
      ],
      'all_dependent_settings': {
        'include_dirs': [
          'include',
          'objc',
        ],
      },
    },
    {
      'target_name': 'libtodoapp_android',
      'android_unmangled_name': 1,
      'type': 'shared_library',
      'dependencies': [
        'deps/djinni/support-lib/support_lib.gyp:djinni_jni',
        'deps/sqlite3.gyp:sqlite3',
      ],
      'ldflags' : [ '-llog' ],
      'sources': [
        '<!@(python deps/djinni/example/glob.py android/jni *.cpp *.hpp)',
        '<!@(python deps/djinni/example/glob.py android/jni_gen *.cpp *.hpp)',
      ],
      'include_dirs': [
        'include',
        'src/interface',
      ],
      'all_dependent_settings': {
        'include_dirs': [
          'include',
          'src/interface',
        ],
      },
    },
  ],
}