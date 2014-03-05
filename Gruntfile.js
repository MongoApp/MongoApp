module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        curl: {
            "tmp/mongodb-osx-x86_64-<%= pkg.mongo_version %>.tgz": "http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-<%= pkg.mongo_version %>.tgz",
        },
        exec: {
            build: {
                cmd: 'xcodebuild',
                // cwd: '.',
                stdout: true,
                stderr: true
            },/**/
        },

    });

    grunt.loadNpmTasks('grunt-exec');

    grunt.registerTask('default', ['exec']);

};