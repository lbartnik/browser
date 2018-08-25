HTMLWidgets.widget({

  name: "browser",
  type: "output",

  factory: function(el, width, height) {

    var shiny = (typeof HTMLWidgets != 'undefined' && HTMLWidgets.shinyMode);

    el = $(el);
    var mainContainer = $("<div>", {class: "main-container"}).appendTo(el);
    var mainContainerEl = mainContainer.get(0);
    var browser = Browser(mainContainerEl);


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
