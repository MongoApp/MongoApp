module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        curl: {
            mongodb: {
              src: 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-<%= pkg.mongo_version %>.tgz',
              dest: 'tmp/mongodb-osx-x86_64-<%= pkg.mongo_version %>.tgz'
            },
        },
        copy: {
          mongodb: {
            files: [{
                expand: true,
                cwd: 'tmp/mongodb-osx-x86_64-<%= pkg.mongo_version %>/',
                src: ['**'],
                dest: 'mongodb/',
                mode: true
            }]
          }
        },
        exec: {
            unzip: {
                cmd: 'cd ./tmp && tar zxvf mongodb-osx-x86_64-<%= pkg.mongo_version %>.tgz',
                // cwd: '.',
                stdout: true,
                stderr: true
            },
            chmod: {
                cmd: 'chmod +x ./mongodb/bin/*',
                // cwd: '.',
                stdout: true,
                stderr: true
            },
            build: {
                cmd: 'xcodebuild',
                // cwd: '.',
                stdout: true,
                stderr: true
            },/**/
        },

    });

    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-curl');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('download', ['curl']);
    grunt.registerTask('unzip', ['exec:unzip', 'copy:mongodb', 'exec:chmod']);
    grunt.registerTask('build', ['exec:build']);

    grunt.registerTask('default', ['download', 'unzip', 'build']);

};