HTMLWidgets.widget({

  name: "browser",
  type: "output",

  factory: function(el, width, height) {

    var browser = Browser(el);

    // return widget instance
    return {
      renderValue: function(input) {
        if ('knitr' in input.options) {
          browser.setOption('knitr', input.options.knitr)
        }
        browser.setData(input.data);
      },

      resize: function(width, height) {
        browser.setSize(width, height);
      },

      // Make the vis object available as a property on the widget
      // instance we're returning from factory().
      browser: browser 
    };
  }
});
