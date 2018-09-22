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
      var onLoad;
      onLoad = function onLoad(data) {
        var parsed, rendered;
        parsed = $.parseHTML(Mustache.render(data, model));
        rendered = $(parsed);
        rendered.find("code").each(function (i, block) {
          return hljs.highlightBlock(block);
        });
        rendered.find('.code-block').addClass('invisible');
        return rendered.appendTo(parent);
      };
      // TODO add event handlers
      return $.get(templateUrl, function (data) {
        return tryCatch(onLoad, data);
      });
    };
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
    var artifactDescription, container, selectArtifact, textTreeView, views;
    container = $('<div>', {
      class: 'tree-view'
    }).appendTo(external);
    views = [];
    textTreeView = function textTreeView() {};
    // --- refresh view ---------------------------------------------------
    textTreeView.refresh = function () {
      var _traverse;
      _traverse = function traverse(node) {
        var av, child, el, j, len, ref, results;
        el = $("<div>", {
          class: 'artifact-line'
        }).css("padding-left", node.depth * 20).appendTo(container);
        // TODO remove previous views; maybe employ d3?
        av = ArtifactView(node, el);
        views.push(av);
        ref = node.children;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          child = ref[j];
          results.push(_traverse(child));
        }
        return results;
      };
      return _traverse(model.asTree());
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