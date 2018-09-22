"use strict";

// Generated by CoffeeScript 2.3.1
(function () {
  // --- ArtifactView -----------------------------------------------------

  // @param parent Parent HTML element.
  // @param model  Artifact model (DTO).
  // @param node   D3 tree node object.

  var ArtifactView, TextTreeView;

  ArtifactView = function ArtifactView(model, parent) {
    var artifactView, initialize, templateUrl;
    templateUrl = $("#browser-1-attachment").attr("href");
    initialize = function initialize() {
      return $.get(templateUrl, function (data) {
        var rendered;
        rendered = $("<div>");
        rendered.html(Mustache.render(data, model));
        rendered.find("code").each(function (i, block) {
          return hljs.highlightBlock(block);
        });
        rendered.find('.code-block').addClass('invisible');
        return rendered.appendTo(parent);
      });
    };
    // TODO add event handlers
    artifactView = function artifactView() {};
    artifactView.keypressEnter = function () {
      return container.find('.selected').find('.code-block').toggleClass('invisible');
    };
    // return the instance
    initialize();
    return artifactView;
  };

  // --- TextTreeView -----------------------------------------------------
  TextTreeView = function TextTreeView(external, model) {
    var artifactDescription, container, selectArtifact, textTreeView;
    container = $('<div>', {
      class: 'tree-view'
    }).appendTo(external);
    textTreeView = function textTreeView() {};
    // --- refresh view ---------------------------------------------------
    textTreeView.refresh = function () {
      return model.forEach(function (model) {
        var av;
        return av = ArtifactView(model, container);
      });
    };

    // --- loads and fills artifact detailed description
    artifactDescription = function artifactDescription(a) {
      return element;
    };
    // --- interactions ---------------------------------------------------
    textTreeView.keyboardSignal = function (key) {
      // TODO up/down - walk the list
      // TODO left/right - walk the tree
      if (key === 'enter') {
        return true;
      }
    };
    selectArtifact = function selectArtifact(event) {
      container.find('.flat-artifact').removeClass('selected');
      return $(this).addClass('selected');
    };
    // --- return the view object -----------------------------------------
    log.debug('created view');
    return textTreeView;
  };

  // --- exports ----------------------------------------------------------
  window.TextTreeView = TextTreeView;

  window.ArtifactView = ArtifactView;
}).call(undefined);