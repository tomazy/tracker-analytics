var ciConfig, devConfig, defaultConfig;

function extend(obj, src){
  var propName;

  for (propName in src){
    obj[propName] = src[propName]
  }

  return obj;
}

defaultConfig = {
  specs: ['*-feature.coffee'],
  jasmineNodeOpts: {
    showColors: true
  },
  plugins: ['protractor-coffee-preprocessor']
}

ciConfig = extend(extend({}, defaultConfig), {
  capabilities: {
    browserName: 'phantomjs',
    'phantomjs.binary.path': './node_modules/phantomjs/bin/phantomjs'
  },
})

devConfig = extend(extend({}, defaultConfig), {
  chromeOnly: true,
  chromeDriver: '../../node_modules/protractor/selenium/chromedriver',
  capabilities: {
    browserName: 'chrome'
  },
});

exports.config = process.env.CI ? ciConfig : devConfig;
