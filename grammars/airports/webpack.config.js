const path = require('path');

module.exports = {
  entry: './dist/main.js',
  output: {
    library: 'AirportsParser',
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  node: { fs: 'empty' },
  mode: 'production'
};