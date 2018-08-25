/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// --- DataSet ----------------------------------------------------------

// Create a data set wrapper.
//
// The data set wrapper is handy for the following two reasons:
//   * JSON data received from R might require certain transformations
//   * wrapper acts as an abstraction layer and hides chages in how the
//     data is formatted and/or handled on either side (R and JS browser)
//
// @param raw JSON data received from R.
//
const DataSet = function(raw) {

  const dataset = function() {};

  // Turns a list of elements into a tree.
  const stratified = function() {
    const stratify = d3.stratify()
      .id(d => d.id)
      .parentId(function(d) { if (d.parents != null ? d.parents.length : undefined) { return d.parents[0]; } });
    return stratify(raw);
  };

  // Transforms the raw data into a tree of elements.
  dataset.traverseAsTree = function(f, root) {
    log.debug("traversing as tree");
    var traverse = function(node, parent) {
      f(node.data, parent);
      if (node.children) {
        return Array.from(node.children).map((child) => traverse(child, node.data));
      }
    };
    const strats = stratified();
    console.log(strats.children[0]);
    return traverse(strats, root);
  };
    

  return dataset;
};


// --- exports ----------------------------------------------------------

window.DataSet = DataSet;
