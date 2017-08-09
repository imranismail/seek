'use strict'

const webpack = require('webpack')
const merge = require('webpack-merge')
const path = require('path')
const glob = require('glob')
const parts = require('./webpack.parts')

const SOURCE = path.resolve(__dirname)
const SINK = path.resolve(__dirname, '..', 'priv', 'static')

const defaults = {
  entry: {
    app: [
      require.resolve('./polyfills'),
      path.join(SOURCE, 'js', 'app.js'),
      path.join(SOURCE, 'css', 'app.sass'),
    ]
  },
  output: {
    path: SINK,
    publicPath: '/',
    filename: path.join('js', '[name].js'),
    chunkFilename: path.join('js', '[name].chunk.js'),
  },
  resolve: {
    alias: {
      'react-native': 'react-native-web',
    },
  },
  module: {
    strictExportPresence: true,
  },
}

const common = merge.smart([
  defaults,
  parts.clean(SINK, {root: path.resolve(__dirname, '..')}),
  parts.copy({from: path.join(SOURCE, 'static')}),
  parts.file(),
  parts.url(),
  parts.ignore(),
])

module.exports = (env) => {
  if (env === 'production') {
    return merge([
      common,
      parts.javascript(path.join(SOURCE, 'js')),
      parts.style({
        importLoaders: 1,
        minimize: true,
        sourceMap: true,
      }),
      parts.var('process.env.NODE_ENV', env),
      parts.sourcemap('source-map'),
    ])
  } else {
    return merge([
      common,
      parts.output({
        pathinfo: true,
      }),
      parts.javascript(path.join(SOURCE, 'js'), {cacheDirectory: true}),
      parts.style({
        importLoaders: 1,
      }),
      parts.var('process.env.NODE_ENV', env),
      parts.hmr(),
      parts.sourcemap('cheap-module-source-map'),
      parts.named(),
      parts.performance({hints: false}),
    ])
  }
}
