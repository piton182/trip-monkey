const ParseTreeWalker = require("antlr4").tree.ParseTreeWalker;
const CommonTokenStream = require("antlr4").CommonTokenStream;
const InputStream = require("antlr4").InputStream;

const AirportsLexer = require("./AirportsLexer").AirportsLexer;
const AirportsParser = require("./AirportsParser").AirportsParser;
const AirportsListener = require("./AirportsListener").AirportsListener;

const getAirports = (str) => {
    const lexer = new AirportsLexer(new InputStream(str));
    const tokens = new CommonTokenStream(lexer);
    const parser = new AirportsParser(tokens);
    const extractor = new AirportsListener();

    const airports = [];
    extractor.enterAirport = (ctx) => {
        airports.push(ctx.getText());
    };

    const tree = parser.r(); // parse a compilationUnit
    ParseTreeWalker.DEFAULT.walk(extractor, tree); // initiate walk of tree with listener in use of default walker

    return airports;
};

module.exports = {
    getAirports
};
