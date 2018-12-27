const { exec } = require('child_process');

module.exports.executeScript = (pathToScript, scriptTimeout, callback) => {
    let process = exec(`sh ${pathToScript}`, (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
    });


    process.on('exit', code => {
        console.log('Webhook script exit code: ', code);

        clearTimeout(scriptTimer);

        callback(code);
    });

    const scriptTimer = setTimeout(() => {
        process.kill();
        console.warn('script execution timeout');
    }, scriptTimeout);
}
