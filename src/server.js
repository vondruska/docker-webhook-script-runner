const { createServer } = require('http');
const { executeScript } = require('./script-runner');

const TOKEN = process.env.TOKEN || 'thisisunsafe';
const TOKEN_URL = `/${TOKEN}`;
const WEBHOOK_SCRIPT = process.env.WEBHOOK_SCRIPT || '/scripts/helloworld.sh';
const SCRIPT_EXECUTION_TIMEOUT = process.env.SCRIPT_EXECUTION_TIMEOUT || 30000;

// Create an instance of the http server to handle HTTP requests
const app = createServer();

app.on('request', (request, response) => {  
    try {
        const {url, method} = request;
        console.log(`${new Date()} - ${url}`);

        // Set a response type of plain text for the response
        response.setHeader('Content-Type', 'application/json');

        if(url == TOKEN_URL) {
            executeScript(WEBHOOK_SCRIPT, SCRIPT_EXECUTION_TIMEOUT, (exitCode) => {
                if(exitCode == null || exitCode > 0) {
                    response.statusCode = 500;
                    response.end("{\"status\":\"non_ok_exit_code\"}");
                } else {
                    response.statusCode = 200;
                    response.end("{\"status\":\"great_success\"}");
                }
            });
        } else {
            response.statusCode = 401;
            response.end("{\"status\":\"unauth\"}");
            return;
        }
    }
    catch(ex) {
        console.error(ex);
        response.statusCode = 500;
        response.end("{\"status\":\"crazy_error\"}");
    }
});

console.info('----');
console.info('Printing settings');
console.info('Token: ' + TOKEN);
console.info('Webhook script: ' + WEBHOOK_SCRIPT);
console.info('Script Execution Timeout (ms): ' + SCRIPT_EXECUTION_TIMEOUT);
console.info('----');

process.on('SIGTERM', () => {
    app.close();
  });

app.listen(9080, '0.0.0.0');
console.log('Node server running on port 9080');