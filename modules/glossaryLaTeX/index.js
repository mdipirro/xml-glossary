/**
 * Created by matteo on 29/02/16.
 */

exports.main = function (args) {
    const exec = require('child_process').exec;
    exec('perl plugins/mdipirro/xml-glossary/modules/glossaryLaTeX/createLaTeX.pl ' + args[0],
        function (err, stdout, stderr) {
            if (err) {
                console.log('An error has occurred. Please contact the plugin creator. ' + err);
            }
            console.log('LaTeX code successfully created!!');
        }
    );
}