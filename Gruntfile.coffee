'use strict'

path = require('path')

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.initConfig
    clean:
      app:
        files: [
          dot: true
          src: [
            'www'
            'tmp'
          ]
        ]

    coffee:
      options:
        sourceMap: true
        sourceRoot: ''

      app:
        expand: true
        cwd:  'src'
        src:  'scripts/**/*.coffee'
        dest: 'tmp'
        ext:  '.js'

    jade:
      options:
        pretty: true
        data:
          testing: false
      app:
        files: [
          expand: true
          cwd:  'src'
          src:  '**/*.jade'
          dest: 'tmp'
          ext:  '.html'
        ]

    sass:
      app:
        files: [
          expand: true
          cwd:  'src'
          src:  'styles/**/*.scss'
          dest: 'tmp'
          ext:  '.css'
        ]

    useminPrepare:
      html: "tmp/index.html"
      options:
        dest: 'www'

    usemin:
      html: [ 'www/index.html' ]
      css: [ 'www/styles/{,*/}*.css' ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: 'tmp'
          dest: 'www'
          src: [
            'index.html'
          ]
        ,
          expand: true
          cwd: 'bower_components/bootstrap-sass-official/assets'
          src: 'fonts/**/*.*'
          dest: 'www'
        ]

    watch:
      client:
        files: [ 'src/scripts/{,*/}*.coffee' ]
        tasks: [ 'coffee' ]
        options:
          livereload: true

      clientCss:
        files: [ 'src/styles/{,*/}*.scss' ]
        tasks: [ 'sass' ]
        options:
          livereload: true

      clientHtml:
        files: [ 'src/{,*/}*.jade' ]
        tasks: [ 'jade' ]
        options:
          livereload: true

      karma:
        files: [
          'src/scripts/{,*/}*.coffee'
          'test/{,*/}*-test.coffee'
        ]
        tasks: [ 'karma:unit:run' ]

    connect:
      options:
        hostname: '0.0.0.0'
      devel:
        options:
          port: 9000
          middleware: (connect, options)->
            [
              require('connect-livereload')()
              connect().use('/', connect.static('./tmp'))
              connect().use('/bower_components', connect.static('./bower_components'))
              connect().use('/fonts', connect.static('./bower_components/bootstrap-sass-official/assets/fonts'))
              connect().use('/styles/bower_components', connect.static('./bower_components'))
              connect().use('/scripts', connect.static('./src/scripts')) # for coffee files
            ]
      release:
        options:
          port: 9001
          keepalive: true
          middleware: (connect, options)->
            [
              connect().use('/', connect.static('./www'))
            ]

    karma:
      options:
        reporters: 'dots'
        configFile: 'test/karma.conf.coffee'
      unit:
        background: true
        autoWatch: false
      ci:
        singleRun: true

    inline_angular_templates:
      dist:
        options:
          base: 'tmp'
        files:
          'tmp/index.html': [ 'tmp/templates/*.html' ]

    shell:
      testFeatures:
        command: './node_modules/.bin/protractor test/features/conf.js'

      selenium:
        command: './node_modules/.bin/webdriver-manager start'

      install_selenium:
        command: './node_modules/.bin/webdriver-manager update --standalone'

  grunt.registerTask 'build', ->
    grunt.task.run [
      'clean'
      'coffee'
      'jade'
      'inline_angular_templates'
      'sass'
      'useminPrepare'
      'concat'
      'cssmin'
      'copy:dist'
      'uglify'
      'usemin'
    ]

  grunt.registerTask 'devel', 'Run the app in development mode', () ->
    process.env['PORT'] = grunt.config.get('connect.devel.options.port')

    grunt.task.run [
      'coffee'
      'sass'
      'jade'
      'connect:devel'
      'karma:unit:start'
      'watch'
    ]

  grunt.registerTask 'test', 'Run all tests', ->
    grunt.task.run [
      'build'
      'test:unit'
      'test:features'
    ]

  grunt.registerTask 'test:unit', 'Run unit tests', ->
    grunt.config.set('karma.unit.background', false)
    grunt.config.set('karma.unit.singleRun', true)

    grunt.task.run [
      'karma:unit'
    ]

  grunt.registerTask 'test:features', 'Run feature tests', ->
    port = 9002

    grunt.config.set('connect.release.options.keepalive', false)
    grunt.config.set('connect.release.options.port', port)

    process.env['PORT'] = port

    grunt.task.run [
      'connect:release'
      'shell:install_selenium'
      'shell:testFeatures'
    ]

  grunt.registerTask 'default', ['build']
