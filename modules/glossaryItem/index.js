/**
 * Created by matteo on 29/02/16.
 */

exports.main = function (args) {
    const exec = require('child_process').exec;
    exec('perl plugins/mdipirro/xml-glossary/modules/glossaryItem/glossaryItem.pl ' + args[0] + ' ' + args[1],
        function (err, stdout, stderr) {
            if (err) {
                console.log('An error has occurred. Please contact the plugin creator. ' + err);
            }
            console.log('LaTeX code successfully created!!');
        }
    );
}