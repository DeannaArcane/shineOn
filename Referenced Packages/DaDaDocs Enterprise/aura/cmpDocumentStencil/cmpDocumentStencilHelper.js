({
  generateArrayOfIndexes: function (length) {
    var arr = new Array(length).fill(null);

    return arr.map(function (item, index) {
      return index;
    });
  }
});