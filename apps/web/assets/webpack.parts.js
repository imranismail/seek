'use strict'

const webpack = require('webpack')
const path = require('path')
const autoprefixer = require('autoprefixer')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const CleanWebpackPlugin = require('clean-webpack-plugin')
const postcssFlexbugsFixes = require('postcss-flexbugs-fixes')

exports.entry = (entry) => ({
  entry: entry,
})

exports.output = (output) => ({
  output
})

exports.file = () => ({
  module: {
    rules: [
      {
        exclude: [
          /\.html$/,
          /\.(js|jsx)$/,
          /\.css$/,
          /\.json$/,
          /\.bmp$/,
          /\.gif$/,
          /\.jpe?g$/,
          /\.png$/,
          /\.less$/,
          /\.sass$/,
          /\.scss$/,
        ],
        loader: require.resolve('file-loader'),
        options: {
          name: 'images/[name].[ext]',
        },
      },
    ],
  },
})

exports.url = () => ({
  module: {
    rules: [
      {
        test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
        loader: require.resolve('url-loader'),
        options: {
          limit: 10000,
          name: 'images/[name].[ext]',
        },
      },
    ],
  },
})

exports.javascript = (include, options = {}) => ({
  module: {
    rules: [
      {
        test: /\.(jsx?)$/,
        include,
        loader: require.resolve('babel-loader'),
        options,
      },
    ],
  },
})

exports.style = (options) => ({
  module: {
    rules: [
      {
        test: /\.(scss|sass)$/,
        loader: ExtractTextPlugin.extract({
          fallback: require.resolve('style-loader'),
          use: [
            {
              loader: require.resolve('css-loader'),
              options
            },
            {
              loader: require.resolve('postcss-loader'),
              options: {
                ident: 'postcss',
                plugins: () => [
                  postcssFlexbugsFixes,
                  autoprefixer({
                    browsers: [
                      '>1%',
                      'last 4 versions',
                      'Firefox ESR',
                      'not ie < 9', // React doesn't support IE8 anyway
                    ],
                    flexbox: 'no-2009',
                  }),
                ],
              },
            },
            {
              loader: 'sass-loader',
            },
          ],
        }),
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({
          fallback: require.resolve('style-loader'),
          use: [
            {
              loader: require.resolve('css-loader'),
              options
            },
            {
              loader: require.resolve('postcss-loader'),
              options: {
                ident: 'postcss',
                plugins: () => [
                  postcssFlexbugsFixes,
                  autoprefixer({
                    browsers: [
                      '>1%',
                      'last 4 versions',
                      'Firefox ESR',
                      'not ie < 9', // React doesn't support IE8 anyway
                    ],
                    flexbox: 'no-2009',
                  }),
                ],
              },
            },
          ],
        }),
      },
    ],
  },
  plugins: [
    new ExtractTextPlugin(path.join('css', '[name].css')),
  ],
})

exports.var = (key, val) => ({
  plugins: [
    new webpack.DefinePlugin({
      [key]: JSON.stringify(val),
    }),
  ]
})

exports.hmr = () => ({
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
  ]
})

exports.ignore = () => ({
  plugins: [
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
  ],
  node: {
    fs: 'empty',
    net: 'empty',
    tls: 'empty',
  },
})

exports.clean = (path, options) => ({
  plugins: [
    new CleanWebpackPlugin([path], options),
  ],
})

exports.copy = (options) => ({
  plugins: [
    new CopyWebpackPlugin([options]),
  ],
})

exports.sourcemap = (type) => ({
  devtool: type,
})

exports.named = () => ({
  plugins: [
    new webpack.NamedModulesPlugin(),
  ],
})

exports.performance = (performance) => ({
  performance,
})
