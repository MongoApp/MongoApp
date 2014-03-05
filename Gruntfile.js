module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
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